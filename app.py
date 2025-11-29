# app.py

import os
import json
import random
import re 
from flask import Flask, render_template, request, jsonify, url_for, make_response, session, redirect, send_from_directory
from flask_sqlalchemy import SQLAlchemy
# از Flask-Limiter استفاده نمی‌کنیم تا از مشکلات نصب جلوگیری کنیم
from dotenv import load_dotenv
from datetime import datetime, timedelta
from sqlalchemy import inspect
from sqlalchemy import func, or_
from urllib.parse import unquote
import random
import hashlib
import os
import secrets
import string
import hashlib
import hmac
import time
sys_random = random.SystemRandom()
import jdatetime
import logging
import json as _json
from urllib.parse import quote_plus
import urllib.request
import urllib.error
from werkzeug.utils import secure_filename
try:
    from PIL import Image
except Exception:
    Image = None

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler("app.log", encoding="utf-8"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Optional translation providers (no hard dependency)
try:
    from deep_translator import GoogleTranslator as DTGoogleTranslator
except Exception:
    DTGoogleTranslator = None
try:
    from deep_translator import MyMemoryTranslator as DTMyMemoryTranslator
except Exception:
    DTMyMemoryTranslator = None

# Simple in-memory translation cache
_translate_cache = {}

def _detect_source_lang(text: str) -> str:
    t = text.strip()
    # ساده: اگر حروف فارسی/عربی دیدیم، fa; در غیر این صورت en
    for ch in t:
        if '\u0600' <= ch <= '\u06FF' or '\u0750' <= ch <= '\u077F' or '\u08A0' <= ch <= '\u08FF':
            return 'fa'
    return 'en'

def translate_text_to(text: str, target_lang: str = 'fa') -> str:
    """Translate given text to target language using available providers.
    Falls back gracefully if no provider is available.
    """
    key = (text.strip(), target_lang.lower())
    if key in _translate_cache:
        return _translate_cache[key]
    cleaned = text.strip()
    if not cleaned:
        return ''
    translated = None
    source_lang = _detect_source_lang(cleaned)
    # تشخیص تک‌واژه یا جمله
    import re as _re
    is_single_word = bool(_re.match(r"^[\w'-]+$", cleaned))
    # Prefer Google via deep_translator if available
    try:
        if DTGoogleTranslator is not None:
            translated = DTGoogleTranslator(source=source_lang, target=target_lang).translate(cleaned)
    except Exception:
        translated = None
    # Fallback to MyMemory if needed
    if translated is None or str(translated).strip().lower() == cleaned.lower():
        try:
            if DTMyMemoryTranslator is not None:
                translated = DTMyMemoryTranslator(source=source_lang, target=target_lang).translate(cleaned)
        except Exception:
            translated = None
    # Final network fallback: use unofficial Google endpoint (also try to extract up to 3 dictionary senses)
    if translated is None or str(translated).strip().lower() == cleaned.lower():
        try:
            q = quote_plus(cleaned)
            url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl={source_lang}&tl={target_lang}&dt=t&dt=bd&q={q}"
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=6) as resp:
                data = resp.read().decode('utf-8', 'ignore')
            arr = _json.loads(data)
            parts = [seg[0] for seg in (arr[0] or []) if seg and isinstance(seg, list) and seg[0]]
            base_text = ''.join(parts) if parts else ''
            if is_single_word:
                # Try to collect up to 3 dictionary senses for single words only
                alt_meanings = []
                if isinstance(arr, list) and len(arr) > 1 and isinstance(arr[1], list):
                    for entry in arr[1]:
                        if isinstance(entry, list):
                            if len(entry) > 1 and isinstance(entry[1], list):
                                for term in entry[1]:
                                    if isinstance(term, list) and term and isinstance(term[0], (str,)):
                                        alt_meanings.append(term[0])
                            if len(entry) > 2 and isinstance(entry[2], list):
                                for term in entry[2]:
                                    if isinstance(term, str):
                                        alt_meanings.append(term)
                seen = set(); unique_alts = []
                for it in alt_meanings:
                    it = str(it).strip()
                    if not it or it.lower() == cleaned.lower():
                        continue
                    if it not in seen:
                        seen.add(it); unique_alts.append(it)
                translated = ', '.join(unique_alts[:3]) if unique_alts else (base_text or cleaned)
            else:
                # Sentence: use the full translated sentence (closer to Google UI)
                translated = base_text or cleaned
        except Exception:
            translated = translated  # keep previous
    # Final fallback: echo original
    if translated is None:
        translated = cleaned
    _translate_cache[key] = translated
    return translated

load_dotenv()  # بارگذاری متغیرهای محیطی از .env

app = Flask(__name__)

# Rate Limiting ساده بدون کتابخانه خارجی
rate_limit_storage = {}

# تنظیمات اتصال به MySQL
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+mysqlconnector://{os.getenv('MYSQL_USER')}:{os.getenv('MYSQL_PASSWORD')}"
    f"@{os.getenv('MYSQL_HOST')}/{os.getenv('MYSQL_DB')}?charset=utf8mb4"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
    'pool_pre_ping': True
}
# آواتار
app.config['UPLOAD_FOLDER'] = os.path.join(os.path.dirname(__file__), 'static', 'uploads', 'avatars')
app.config['MAX_CONTENT_LENGTH'] = 2 * 1024 * 1024  # 2MB
ALLOWED_AVATAR_EXTS = {'.jpg', '.jpeg', '.png', '.gif', '.webp'}
DEFAULT_AVATAR_URL = '/static/images/default-avatar.svg'

# تنظیمات session برای admin
app.secret_key = os.getenv('SECRET_KEY', 'your-secret-key-change-this-in-production')

# فیلترهای Jinja2
@app.template_filter('nl2br')
def nl2br_filter(text):
    """تبدیل خط جدید به <br>"""
    if text:
        return text.replace('\n', '<br>')
    return text

# اطلاعات admin (در محیط واقعی باید در دیتابیس ذخیره شود)
ADMIN_CREDENTIALS = {
    'admin': {
        'username': 'admin',
        'password_hash': hashlib.sha256('admin123'.encode()).hexdigest(),
        'name': 'مدیر سیستم'
    }
}
print(f"DEBUG: DATABASE_URL being used: {app.config['SQLALCHEMY_DATABASE_URI']}")

db = SQLAlchemy(app)

# Decorator برای محافظت از صفحات admin
def admin_required(f):
    def decorated_function(*args, **kwargs):
        if 'admin_logged_in' not in session:
            return redirect(url_for('admin_login'))
        return f(*args, **kwargs)
    decorated_function.__name__ = f.__name__
    return decorated_function

class Question(db.Model):
    __tablename__ = 'questions'
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(255))
    order_num = db.Column(db.Integer)
    question_text = db.Column(db.Text)
    option1 = db.Column(db.String(255))
    option2 = db.Column(db.String(255))
    option3 = db.Column(db.String(255))
    option4 = db.Column(db.String(255))
    correct_answer = db.Column(db.String(255))
    fa_explanation = db.Column(db.Text)  # توضیح فارسی
    kur_explanation = db.Column(db.Text)  # توضیح کوردی
    eng_explanation = db.Column(db.Text)  # توضیح انگلیسی
    # سایر ستون‌ها در صورت نیاز اضافه شود

class StudentQuiz(db.Model):
    __tablename__ = 'student_quiz'
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(255))
    question_text = db.Column(db.Text)
    option1 = db.Column(db.String(255))
    option2 = db.Column(db.String(255))
    option3 = db.Column(db.String(255))
    option4 = db.Column(db.String(255))
    correct_answer = db.Column(db.String(255))
    unit = db.Column(db.String(255))
    content = db.Column(db.String(255))  # موضوع گرامر
    fa_explanation = db.Column(db.Text)  # توضیح فارسی
    kur_explanation = db.Column(db.Text)  # توضیح کوردی
    eng_explanation = db.Column(db.Text)  # توضیح انگلیسی
    # سایر ستون‌ها در صورت نیاز اضافه شود

class Result(db.Model):
    __tablename__ = 'results'
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(255))
    quiz_name = db.Column(db.String(255))
    score = db.Column(db.Integer)
    total_questions = db.Column(db.Integer)
    created_at = db.Column(db.DateTime)
    public = db.Column(db.Boolean, default=True)
    selected_grammars = db.Column(db.Text, default=None)

class ResultItem(db.Model):
    __tablename__ = 'result_items'
    id = db.Column(db.Integer, primary_key=True)
    result_id = db.Column(db.Integer, nullable=False, index=True)
    question_id = db.Column(db.Integer)
    question_type = db.Column(db.String(50))
    question_text = db.Column(db.Text)
    options = db.Column(db.JSON)  # برای MCQ: آرایه 4 گزینه‌ای
    user_answer = db.Column(db.Text)
    correct_answer = db.Column(db.Text)
    is_correct = db.Column(db.Boolean, default=False)
    fa_explanation = db.Column(db.Text)
    kur_explanation = db.Column(db.Text)
    eng_explanation = db.Column(db.Text)

class Book(db.Model):
    __tablename__ = 'books'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    level = db.Column(db.String(100))
    language = db.Column(db.String(50))
    description = db.Column(db.Text)
    cover_url = db.Column(db.String(500))
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, onupdate=datetime.utcnow)

class BookQuestion(db.Model):
    __tablename__ = 'book_questions'
    id = db.Column(db.Integer, primary_key=True)
    book_id = db.Column(db.Integer, nullable=False)
    unit_number = db.Column(db.String(100), nullable=False)
    question_text = db.Column(db.Text, nullable=False)
    question_type = db.Column(db.String(50), nullable=False)
    option1 = db.Column(db.String(255))
    option2 = db.Column(db.String(255))
    option3 = db.Column(db.String(255))
    option4 = db.Column(db.String(255))
    correct_answer = db.Column(db.String(255))
    fa_explanation = db.Column(db.Text)
    kur_explanation = db.Column(db.Text)
    eng_explanation = db.Column(db.Text)

class BookMatching(db.Model):
    __tablename__ = 'book_matching'
    id = db.Column(db.Integer, primary_key=True)
    book_question_id = db.Column(db.Integer, nullable=False)
    left_item = db.Column(db.String(255), nullable=False)
    right_item = db.Column(db.String(255), nullable=False)
    # pair_order column does not exist in current DB schema

class WrongQuestion(db.Model):
    __tablename__ = 'wrong_questions'
    id = db.Column(db.Integer, primary_key=True)
    question_id = db.Column(db.Integer, nullable=False)
    question_text = db.Column(db.Text, nullable=False)
    options = db.Column(db.JSON, nullable=False)
    correct_answer = db.Column(db.String(255), nullable=False)
    user_ip = db.Column(db.String(45))
    quiz_name = db.Column(db.String(255))
    content = db.Column(db.String(255))
    question_type = db.Column(db.String(255), default='')  # نوع آزمون یا کد آزمون
    reported_reason = db.Column(db.String(255), default='سایر')  # دلیل گزارش (متن فارسی)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.Enum('pending', 'reviewed', 'fixed', 'rejected'), default='pending')
    user_name = db.Column(db.String(255)) # Added user_name column
    fa_explanation = db.Column(db.Text)
    kur_explanation = db.Column(db.Text)
    eng_explanation = db.Column(db.Text)

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=True)  # Nullable for future OAuth
    email = db.Column(db.String(255), unique=True, nullable=False)
    display_name = db.Column(db.String(150))
    avatar_url = db.Column(db.String(500))
    is_email_verified = db.Column(db.Boolean, default=False)
    terms_accepted = db.Column(db.Boolean, default=False)
    terms_accepted_at = db.Column(db.DateTime)
    last_login = db.Column(db.DateTime)
    failed_login_attempts = db.Column(db.Integer, default=0)
    locked_until = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Article(db.Model):
    __tablename__ = 'articles'
    id = db.Column(db.Integer, primary_key=True)
    title_fa = db.Column(db.String(255), nullable=False)  # عنوان فارسی
    title_ku = db.Column(db.String(255), nullable=False)  # عنوان کوردی
    title_en = db.Column(db.String(255), nullable=False)  # عنوان انگلیسی
    excerpt_fa = db.Column(db.Text)                       # خلاصه فارسی
    excerpt_ku = db.Column(db.Text)                       # خلاصه کوردی
    excerpt_en = db.Column(db.Text)                       # خلاصه انگلیسی
    tags_fa = db.Column(db.String(500))                   # تگ‌های فارسی (جدا شده با کاما)
    tags_ku = db.Column(db.String(500))                   # تگ‌های کوردی (جدا شده با کاما)
    tags_en = db.Column(db.String(500))                   # تگ‌های انگلیسی (جدا شده با کاما)
    views = db.Column(db.Integer, default=0)              # تعداد بازدید
    is_published = db.Column(db.Boolean, default=True)    # منتشر شده یا نه
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, onupdate=datetime.utcnow)
    author_id = db.Column(db.Integer, db.ForeignKey('users.id'))  # نویسنده مقاله
    category = db.Column(db.String(100))                  # دسته‌بندی (گرامر، واژگان، و...)
    reading_time = db.Column(db.Integer)                  # زمان مطالعه (دقیقه)
    featured_image = db.Column(db.String(500))            # تصویر شاخص مقاله
    
    # رابطه با بلاک‌ها
    blocks = db.relationship('ArticleBlock', backref='article', lazy='dynamic', order_by='ArticleBlock.order_num')

class ArticleBlock(db.Model):
    __tablename__ = 'article_blocks'
    id = db.Column(db.Integer, primary_key=True)
    article_id = db.Column(db.Integer, db.ForeignKey('articles.id', ondelete='CASCADE'), nullable=False)
    block_type = db.Column(db.Enum(
        'paragraph', 'example', 'note', 'image', 'subtitle', 'video', 'audio', 'file',
        'quote', 'code', 'table', 'list', 'divider', 'callout', 'exercise', 'vocabulary'
    ), nullable=False)
    content_fa = db.Column(db.Text)                       # محتوای فارسی
    content_ku = db.Column(db.Text)                       # محتوای کوردی
    content_en = db.Column(db.Text)                       # محتوای انگلیسی
    order_num = db.Column(db.Integer, nullable=False, default=0)  # ترتیب نمایش
    block_metadata = db.Column(db.JSON)                   # اطلاعات اضافی
    is_active = db.Column(db.Boolean, default=True)       # فعال یا غیرفعال
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, onupdate=datetime.utcnow)

@app.route('/')
def home():
    videos = [
        {
            'url': 'https://youtu.be/sX194xPwT4k?si=yZarvhuIIzIMksiy',
            'thumb': url_for('static', filename='images/th1.jpg')
        },
        {
            'url': 'https://www.youtube.com/watch?v=FTMC9FrH3EU&t=36s',
            'thumb': url_for('static', filename='images/th2.jpg')
        },
        {
            'url': 'https://www.youtube.com/watch?v=olLREwc7D08',
            'thumb': url_for('static', filename='images/th3.jpg')
        },
        {
            'url': 'https://www.youtube.com/watch?v=olLREwc7D08',
            'thumb': url_for('static', filename='images/th4.jpg')
        },
        {
            'url': 'https://www.youtube.com/watch?v=FNemaHZatus&pp=0gcJCd4JAYcqIYzv',
            'thumb': url_for('static', filename='images/th5.jpg')
        }
    ]
    return render_template('home_new.html', videos=videos)
# --------- Auth minimal ---------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        try:
            data = request.get_json(silent=True) or request.form
            username = (data.get('username') or '').strip()
            password = (data.get('password') or '').strip()
            if not username or not password:
                return jsonify({'success': False, 'message': 'نام کاربری و رمز عبور الزامی است'}), 400
            # اجازه ورود با نام کاربری یا ایمیل
            user = User.query.filter((User.username == username) | (User.email == username)).first()
            if not user:
                return jsonify({'success': False, 'message': 'کاربر یافت نشد'}), 404
            if hashlib.sha256(password.encode()).hexdigest() != user.password_hash:
                return jsonify({'success': False, 'message': 'رمز عبور اشتباه است'}), 401
            session['uid'] = user.id
            session['uname'] = user.display_name or user.username
            session['user_avatar'] = user.avatar_url or DEFAULT_AVATAR_URL
            return jsonify({'success': True})
        except Exception as e:
            logger.error(f"Login error: {str(e)}", exc_info=True)
            error_msg = 'خطا در ارتباط با سرور'
            if 'mysql' in str(e).lower() or 'database' in str(e).lower() or 'connection' in str(e).lower():
                error_msg = 'خطا در اتصال به پایگاه داده'
            return jsonify({'success': False, 'message': error_msg}), 500
    
    # اگر کاربر قبلاً لاگین کرده، به پروفایل هدایت شود
    if 'uid' in session:
        return redirect(url_for('profile'))
    
    return render_template('auth.html', active_tab='login')

# توابع امنیتی
def hash_password(password):
    """هش کردن رمز عبور با PBKDF2 (جایگزین bcrypt)"""
    salt = secrets.token_hex(16)
    password_hash = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt.encode('utf-8'), 100000)
    return f"{salt}:{password_hash.hex()}"

def verify_password(password, password_hash):
    """بررسی رمز عبور"""
    try:
        salt, stored_hash = password_hash.split(':')
        password_hash_check = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt.encode('utf-8'), 100000)
        return hmac.compare_digest(password_hash_check.hex(), stored_hash)
    except:
        return False

def validate_password_strength(password):
    """بررسی قدرت رمز عبور"""
    if len(password) < 6:
        return False, "رمز عبور باید حداقل 6 کاراکتر باشد"
    
    return True, "رمز عبور معتبر است"

def generate_secure_username(email):
    """تولید نام کاربری امن از ایمیل"""
    local_part = email.split('@')[0]
    # حذف کاراکترهای غیرمجاز
    username = re.sub(r'[^a-zA-Z0-9_]', '', local_part)
    # اضافه کردن عدد تصادفی برای یکتایی
    random_suffix = ''.join(secrets.choice(string.digits) for _ in range(4))
    return f"{username}_{random_suffix}"

# تابع Rate Limiting ساده
def check_rate_limit(ip, limit=5, window=60):
    """بررسی محدودیت درخواست"""
    current_time = time.time()
    if ip not in rate_limit_storage:
        rate_limit_storage[ip] = []
    
    # حذف درخواست‌های قدیمی
    rate_limit_storage[ip] = [req_time for req_time in rate_limit_storage[ip] if current_time - req_time < window]
    
    if len(rate_limit_storage[ip]) >= limit:
        return False
    
    rate_limit_storage[ip].append(current_time)
    return True

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # بررسی Rate Limiting
        client_ip = request.remote_addr
        if not check_rate_limit(client_ip, limit=5, window=60):
            return jsonify({'success': False, 'message': 'تعداد درخواست‌ها زیاد است. لطفاً کمی صبر کنید'}), 429
        
        try:
            data = request.get_json(silent=True) or request.form
            username = (data.get('username') or '').strip()
            email = (data.get('email') or '').strip().lower()
            password = (data.get('password') or '').strip()
            display_name = (data.get('display_name') or '').strip() or username
            terms_accepted = data.get('terms_accepted', False)
            
            # اعتبارسنجی فیلدهای ضروری
            if not email:
                return jsonify({'success': False, 'message': 'ایمیل الزامی است'}), 400
            
            if not password:
                return jsonify({'success': False, 'message': 'رمز عبور الزامی است'}), 400
            
            if not terms_accepted:
                return jsonify({'success': False, 'message': 'لطفاً قوانین و شرایط استفاده را بپذیرید'}), 400
            
            # اعتبارسنجی فرمت ایمیل
            email_pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
            if not re.match(email_pattern, email):
                return jsonify({'success': False, 'message': 'فرمت ایمیل نامعتبر است'}), 400
            
            # بررسی قدرت رمز عبور
            is_strong, password_message = validate_password_strength(password)
            if not is_strong:
                return jsonify({'success': False, 'message': password_message}), 400
            
            # تولید نام کاربری از ایمیل اگر ارائه نشده
            if not username:
                username = generate_secure_username(email)
            
            # بررسی یکتا بودن ایمیل و نام کاربری
            if User.query.filter_by(email=email).first():
                return jsonify({'success': False, 'message': 'این ایمیل قبلاً ثبت شده است'}), 400
            
            if User.query.filter_by(username=username).first():
                return jsonify({'success': False, 'message': 'این نام کاربری قبلاً ثبت شده است'}), 400
            
            # ایجاد کاربر جدید
            user = User(
                username=username,
                password_hash=hash_password(password),
                email=email,
                display_name=display_name,
                avatar_url=DEFAULT_AVATAR_URL,  # آواتار پیش‌فرض
                terms_accepted=True,
                terms_accepted_at=datetime.utcnow(),
                is_email_verified=False  # نیاز به تایید ایمیل
            )
            
            db.session.add(user)
            db.session.commit()
            
            # ورود خودکار بعد از ثبت نام موفق
            session['uid'] = user.id
            session['uname'] = user.display_name or user.username
            session['user_avatar'] = user.avatar_url or DEFAULT_AVATAR_URL
            
            return jsonify({
                'success': True, 
                'message': 'ثبت نام با موفقیت انجام شد',
                'user_id': user.id
            })
            
        except Exception as e:
            db.session.rollback()
            app.logger.error(f"خطا در ثبت نام: {str(e)}")
            return jsonify({'success': False, 'message': 'خطا در ثبت نام. لطفاً دوباره تلاش کنید'}), 500
    
    # اگر کاربر قبلاً لاگین کرده، به پروفایل هدایت شود
    if 'uid' in session:
        return redirect(url_for('profile'))
    
    return render_template('auth.html', active_tab='signup')

# Google OAuth حذف شد تا از مشکلات نصب جلوگیری شود
# می‌توانید بعداً با نصب کتابخانه‌های Google آن را اضافه کنید

@app.route('/check-username', methods=['POST'])
def check_username():
    """بررسی یکتا بودن نام کاربری"""
    try:
        data = request.get_json()
        username = (data.get('username') or '').strip()
        
        if not username:
            return jsonify({'available': False, 'message': 'نام کاربری الزامی است'})
        
        if len(username) < 3:
            return jsonify({'available': False, 'message': 'نام کاربری باید حداقل 3 کاراکتر باشد'})
        
        if not re.match(r'^[a-zA-Z0-9_]+$', username):
            return jsonify({'available': False, 'message': 'نام کاربری فقط می‌تواند شامل حروف، عدد و _ باشد'})
        
        # بررسی وجود نام کاربری
        existing_user = User.query.filter_by(username=username).first()
        
        if existing_user:
            return jsonify({'available': False, 'message': 'این نام کاربری قبلاً استفاده شده است'})
        
        return jsonify({'available': True, 'message': 'نام کاربری در دسترس است'})
        
    except Exception as e:
        app.logger.error(f"خطا در بررسی نام کاربری: {str(e)}")
        return jsonify({'available': False, 'message': 'خطا در بررسی نام کاربری'})

@app.route('/check-email', methods=['POST'])
def check_email():
    """بررسی یکتا بودن ایمیل"""
    try:
        data = request.get_json()
        email = (data.get('email') or '').strip().lower()
        
        if not email:
            return jsonify({'available': False, 'message': 'ایمیل الزامی است'})
        
        # بررسی فرمت ایمیل
        email_pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        if not re.match(email_pattern, email):
            return jsonify({'available': False, 'message': 'فرمت ایمیل نامعتبر است'})
        
        # بررسی وجود ایمیل
        existing_user = User.query.filter_by(email=email).first()
        
        if existing_user:
            return jsonify({'available': False, 'message': 'این ایمیل قبلاً ثبت شده است'})
        
        return jsonify({'available': True, 'message': 'ایمیل در دسترس است'})
        
    except Exception as e:
        app.logger.error(f"خطا در بررسی ایمیل: {str(e)}")
        return jsonify({'available': False, 'message': 'خطا در بررسی ایمیل'})

@app.route('/logout')
def logout():
    session.pop('uid', None)
    session.pop('uname', None)
    session.pop('user_avatar', None)
    return redirect(url_for('home'))

@app.route('/profile')
def profile():
    if 'uid' not in session:
        return redirect(url_for('login'))
    user = User.query.get(session['uid'])
    
    # اگر کاربر آواتار ندارد، آواتار پیش‌فرض را تنظیم کن
    if not user.avatar_url:
        user.avatar_url = DEFAULT_AVATAR_URL
        db.session.commit()
        session['user_avatar'] = DEFAULT_AVATAR_URL
    
    # آمار کامل
    user_results = db.session.query(Result).filter(Result.user_name == session.get('uname')).all()
    total_results = len(user_results)
    
    if total_results > 0:
        # بهترین نمره (درصد)
        best_score = max([round((r.score / r.total_questions) * 100, 1) for r in user_results if r.total_questions > 0])
        
        # میانگین نمره
        total_percentage = sum([(r.score / r.total_questions) * 100 for r in user_results if r.total_questions > 0])
        avg_score = total_percentage / total_results
        
        # کل سوالات
        total_questions = sum([r.total_questions for r in user_results])
    else:
        best_score = 0
        avg_score = 0
        total_questions = 0
    
    # مدال‌ها: بر اساس تعداد نتایج (برنز/نقره/طلا) و بهترین نمره
    medals = []
    if total_results >= 5: medals.append('🥉')
    if total_results >= 20: medals.append('🥈')
    if total_results >= 50: medals.append('🥇')
    if best_score and best_score >= 80: medals.append('🏆')
    
    stats = {
        'total_results': total_results,
        'best_score': best_score,
        'avg_score': avg_score,
        'total_questions': total_questions
    }
    
    # فرمت کردن نتایج برای نمایش در تب تمرینات من (20 نتیجه آخر به ترتیب نزولی تاریخ)
    formatted_results = []
    # داده‌های نمودار
    chart_data = {
        'dates': [],
        'scores': [],
        'correct': 0,
        'incorrect': 0,
        'quiz_labels': [],
        'quiz_scores': []
    }
    
    # داده‌های کارت‌های فعالیت
    activity_cards = {
        'weakest': None,
        'best': None,
        'latest': None
    }
    
    if user_results:
        # مرتب‌سازی بر اساس تاریخ (جدیدترین اول)
        sorted_results = sorted(user_results, key=lambda x: x.created_at if x.created_at else datetime(1970, 1, 1), reverse=True)
        for idx, result in enumerate(sorted_results[:20], 1):
            percentage = round((result.score / result.total_questions) * 100, 1) if result.total_questions > 0 else 0
            formatted_results.append({
                'id': result.id,
                'quiz_name': result.quiz_name,
                'score': result.score,
                'total_questions': result.total_questions,
                'percentage': percentage,
                'created_at': result.created_at.strftime('%Y/%m/%d %H:%M') if result.created_at else ''
            })
        
        # آماده‌سازی داده‌های نمودار (بر اساس تاریخ صعودی)
        chart_results = sorted(user_results, key=lambda x: x.created_at if x.created_at else datetime(1970, 1, 1))
        # محدود به 30 نتیجه آخر برای نمودار پیشرفت
        recent_results = chart_results[-30:]
        
        for res in recent_results:
            p = round((res.score / res.total_questions) * 100, 1) if res.total_questions > 0 else 0
            d = jdatetime.datetime.fromgregorian(datetime=res.created_at).strftime('%Y/%m/%d') if res.created_at else ''
            chart_data['dates'].append(d)
            chart_data['scores'].append(p)
            
            # جمع کل برای نمودار دایره‌ای
            chart_data['correct'] += res.score
            chart_data['incorrect'] += (res.total_questions - res.score)
            
        # داده‌های ۱۰ آزمون آخر برای نمودار ستونی
        last_10 = chart_results[-10:]
        for res in last_10:
            p = round((res.score / res.total_questions) * 100, 1) if res.total_questions > 0 else 0
            # نام کوتاه برای نمودار
            name = res.quiz_name[:15] + '...' if len(res.quiz_name or '') > 15 else (res.quiz_name or 'آزمون')
            chart_data['quiz_labels'].append(name)
            chart_data['quiz_scores'].append(p)
        
        # آماده‌سازی کارت‌های فعالیت
        # آخرین فعالیت (جدیدترین)
        if sorted_results:
            latest = sorted_results[0]
            latest_percentage = round((latest.score / latest.total_questions) * 100, 1) if latest.total_questions > 0 else 0
            latest_date = jdatetime.datetime.fromgregorian(datetime=latest.created_at).strftime('%Y/%m/%d') if latest.created_at else ''
            activity_cards['latest'] = {
                'id': latest.id,
                'quiz_name': latest.quiz_name or 'آزمون',
                'score': latest.score,
                'total_questions': latest.total_questions,
                'percentage': latest_percentage,
                'date': latest_date,
                'correct_answers': latest.score,
                'total_answers': latest.total_questions
            }
        
        # بهترین فعالیت (بالاترین درصد)
        best_result = max(user_results, key=lambda x: (x.score / x.total_questions) if x.total_questions > 0 else 0)
        best_percentage = round((best_result.score / best_result.total_questions) * 100, 1) if best_result.total_questions > 0 else 0
        best_date = jdatetime.datetime.fromgregorian(datetime=best_result.created_at).strftime('%Y/%m/%d') if best_result.created_at else ''
        activity_cards['best'] = {
            'id': best_result.id,
            'quiz_name': best_result.quiz_name or 'آزمون',
            'score': best_result.score,
            'total_questions': best_result.total_questions,
            'percentage': best_percentage,
            'date': best_date,
            'correct_answers': best_result.score,
            'total_answers': best_result.total_questions
        }
        
        # ضعیف‌ترین فعالیت (پایین‌ترین درصد)
        weakest_result = min(user_results, key=lambda x: (x.score / x.total_questions) if x.total_questions > 0 else 1)
        weakest_percentage = round((weakest_result.score / weakest_result.total_questions) * 100, 1) if weakest_result.total_questions > 0 else 0
        weakest_date = jdatetime.datetime.fromgregorian(datetime=weakest_result.created_at).strftime('%Y/%m/%d') if weakest_result.created_at else ''
        activity_cards['weakest'] = {
            'id': weakest_result.id,
            'quiz_name': weakest_result.quiz_name or 'آزمون',
            'score': weakest_result.score,
            'total_questions': weakest_result.total_questions,
            'percentage': weakest_percentage,
            'date': weakest_date,
            'correct_answers': weakest_result.score,
            'total_answers': weakest_result.total_questions
        }
    
    return render_template('profile.html', user=user, stats=stats, medals=medals, user_results=formatted_results, chart_data=chart_data, activity_cards=activity_cards)

@app.route('/debug/create-users-table')
def debug_create_users_table():
    try:
        User.__table__.create(db.engine, checkfirst=True)
        return 'users table is ready (created if it did not exist).'
    except Exception as e:
        return f'Error creating users table: {e}', 500

@app.route('/debug/create-result-items-table')
def debug_create_result_items_table():
    try:
        ResultItem.__table__.create(db.engine, checkfirst=True)
        return 'result_items table is ready (created if it did not exist).'
    except Exception as e:
        return f'Error creating result_items table: {e}', 500

@app.route('/debug/create-articles-tables')
def debug_create_articles_tables():
    try:
        Article.__table__.create(db.engine, checkfirst=True)
        ArticleBlock.__table__.create(db.engine, checkfirst=True)
        return 'articles and article_blocks tables are ready (created if they did not exist).'
    except Exception as e:
        return f'Error creating articles tables: {e}', 500

def _ensure_upload_dir():
    try:
        os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    except Exception as e:
        print(f"Error creating upload directory: {e}")

def extract_excerpt(content, max_lines=3, max_length=200):
    """
    استخراج خلاصه از محتوای HTML
    حذف تگ‌های HTML و استخراج متن خام
    """
    import re
    from bs4 import BeautifulSoup
    
    # حذف تگ‌های HTML
    soup = BeautifulSoup(content, 'html.parser')
    text = soup.get_text()
    
    # تقسیم به خطوط
    lines = [line.strip() for line in text.split('\n') if line.strip()]
    
    # انتخاب خطوط اول
    selected_lines = lines[:max_lines]
    
    # ترکیب خطوط
    excerpt = ' '.join(selected_lines)
    
    # محدود کردن طول
    if len(excerpt) > max_length:
        excerpt = excerpt[:max_length].rsplit(' ', 1)[0] + '...'
    
    return excerpt

@app.route('/profile/avatar', methods=['POST'])
def upload_avatar():
    if 'uid' not in session:
        return redirect(url_for('login'))
    _ensure_upload_dir()
    file = request.files.get('avatar')
    if not file or file.filename.strip() == '':
        return redirect(url_for('profile'))
    filename = secure_filename(file.filename)
    _, ext = os.path.splitext(filename)
    ext = (ext or '').lower()
    if ext not in ALLOWED_AVATAR_EXTS:
        return redirect(url_for('profile'))
    # نام یکتا و خروجی به WebP کم‌حجم
    uid = str(session['uid'])
    new_name = f"u{uid}_{int(datetime.utcnow().timestamp())}.webp"
    save_path = os.path.join(app.config['UPLOAD_FOLDER'], new_name)
    try:
        if Image is not None:
            im = Image.open(file.stream).convert('RGB')
            im.thumbnail((256, 256))
            im.save(save_path, format='WEBP', quality=82, method=6)
        else:
            file.save(save_path)
        # مسیر برای وب
        rel_url = f"/static/uploads/avatars/{new_name}"
        user = User.query.get(session['uid'])
        if user:
            user.avatar_url = rel_url
            session['user_avatar'] = rel_url
            db.session.commit()
    except Exception as e:
        logger.exception('avatar upload error')
    return redirect(url_for('profile'))

@app.route('/api/profile/update-name', methods=['POST'])
def api_update_name():
    if 'uid' not in session:
        return jsonify({'success': False, 'message': 'login_required'}), 401
    data = request.get_json(silent=True) or {}
    new_name = (data.get('display_name') or '').strip()
    if not new_name:
        return jsonify({'success': False, 'message': 'نام خالی است'}), 400
    user = User.query.get(session['uid'])
    if not user:
        return jsonify({'success': False, 'message': 'کاربر یافت نشد'}), 404
    user.display_name = new_name
    session['uname'] = new_name
    db.session.commit()
    return jsonify({'success': True, 'display_name': new_name})

@app.route('/api/my-results')
def api_my_results():
    if 'uid' not in session:
        return jsonify({'success': False, 'message': 'login_required'}), 401
    # صفحه‌بندی ساده
    try:
        page = max(1, int(request.args.get('page', '1')))
        limit_param = (request.args.get('limit') or '10').strip().lower()
        
        # پشتیبانی از limit=all
        if limit_param == 'all':
            per_page = None
        else:
            per_page = max(1, min(int(limit_param), 100))
    except Exception:
        page, per_page = 1, 10
    
    q = db.session.query(Result).filter(Result.user_name == session.get('uname')).order_by(Result.created_at.desc())
    total = q.count()
    
    if per_page is None:
        # وقتی limit=all باشد، همه نتایج را برگردان
        items = q.all()
        per_page = total
    else:
        items = q.limit(per_page).offset((page-1)*per_page).all()
    
    out = []
    for r in items:
        pct = round((r.score / r.total_questions) * 100, 1) if r.total_questions else 0
        try:
            created = jdatetime.datetime.fromgregorian(datetime=r.created_at).strftime('%Y/%m/%d %H:%M') if r.created_at else 'نامشخص'
        except Exception:
            created = 'نامشخص'
        out.append({
            'id': r.id,
            'quiz_name': r.quiz_name,
            'score': r.score,
            'total_questions': r.total_questions,
            'percentage': pct,
            'created_at': created
        })
    return jsonify({'success': True, 'page': page, 'per_page': per_page, 'total': total, 'items': out})

@app.route('/result/<int:result_id>')
def result_detail(result_id: int):
    """صفحه جزئیات نتیجه شامل پاسخ‌های درست/غلط و توضیح آموزشی."""
    try:
        r = Result.query.get(result_id)
        if not r:
            return "نتیجه یافت نشد", 404
        # اگر نتیجه خصوصی باشد، فقط مالک ببیند
        if not r.public:
            if 'uid' not in session or (session.get('uname') or '').strip() != (r.user_name or '').strip():
                return "این نتیجه خصوصی است", 403
        items = ResultItem.query.filter_by(result_id=result_id).all()
        # تاریخ شمسی
        try:
            created = jdatetime.datetime.fromgregorian(datetime=r.created_at).strftime('%Y/%m/%d %H:%M') if r.created_at else 'نامشخص'
        except Exception:
            created = 'نامشخص'
        payload = {
            'id': r.id,
            'user_name': r.user_name or 'کاربر ناشناس',
            'quiz_name': r.quiz_name or 'آزمون',
            'score': r.score,
            'total_questions': r.total_questions,
            'percentage': round((r.score / r.total_questions) * 100, 1) if r.total_questions else 0,
            'created_at': created
        }
        return render_template('result_detail.html', result=payload, items=items)
    except Exception as e:
        logger.exception('result_detail error')
        return "خطای سرور", 500

@app.route('/api/result/<int:result_id>')
def api_result_detail(result_id: int):
    try:
        r = Result.query.get(result_id)
        if not r:
            return jsonify({'success': False, 'message': 'not_found'}), 404
        if not r.public:
            if 'uid' not in session or (session.get('uname') or '').strip() != (r.user_name or '').strip():
                return jsonify({'success': False, 'message': 'forbidden'}), 403
        items = ResultItem.query.filter_by(result_id=result_id).all()
        try:
            created = jdatetime.datetime.fromgregorian(datetime=r.created_at).strftime('%Y/%m/%d %H:%M') if r.created_at else 'نامشخص'
        except Exception:
            created = 'نامشخص'
        return jsonify({
            'success': True,
            'result': {
                'id': r.id,
                'user_name': r.user_name,
                'quiz_name': r.quiz_name,
                'score': r.score,
                'total_questions': r.total_questions,
                'percentage': round((r.score / r.total_questions) * 100, 1) if r.total_questions else 0,
                'created_at': created
            },
            'items': [
                {
                    'id': it.id,
                    'question_id': it.question_id,
                    'question_type': it.question_type,
                    'question_text': it.question_text,
                    'options': it.options,
                    'user_answer': it.user_answer,
                    'correct_answer': it.correct_answer,
                    'is_correct': it.is_correct,
                    'fa_explanation': it.fa_explanation,
                    'kur_explanation': it.kur_explanation,
                    'eng_explanation': it.eng_explanation
                } for it in items
            ]
        })
    except Exception as e:
        logger.exception('api result detail error')
        return jsonify({'success': False, 'message': 'server_error'}), 500

@app.route('/static/uploads/avatars/<path:filename>')
def serve_avatar(filename):
    _ensure_upload_dir()
    resp = send_from_directory(app.config['UPLOAD_FOLDER'], filename, conditional=True, max_age=60*60*24*30)
    try:
        resp.headers['Cache-Control'] = 'public, max-age=2592000, immutable'
    except Exception:
        pass
    return resp



@app.route('/books_vocab')
def books_page():
    """صفحه انتخاب کتاب‌ها (خواندن از دیتابیس)"""
    try:
        books = Book.query.filter_by(is_active=True).order_by(Book.id.asc()).all()
        books_payload = []
        for b in books:
            # استخراج یونیت‌هایی که برایشان سوال وجود دارد
            unit_rows = BookQuestion.query.with_entities(BookQuestion.unit_number).filter_by(book_id=b.id).distinct().all()
            raw_units = [str(u[0]) for u in unit_rows if u and u[0] is not None]
            # مرتب‌سازی: ابتدا عددی، سپس رشته‌ای
            def unit_sort_key(val: str):
                v = val.strip()
                if v.isdigit():
                    return (0, int(v))
                # تلاش برای تبدیل به عدد در صورت وجود کاراکترهای دیگر
                try:
                    return (0, int(''.join(ch for ch in v if ch.isdigit())))
                except Exception:
                    return (1, v)
            units_sorted = sorted(set(raw_units), key=unit_sort_key)
            books_payload.append({
                'id': b.id,
                'title': b.title,
                'level': b.level or '',
                'description': b.description or '',
                'cover_url': b.cover_url or url_for('static', filename='images/th1.jpg'),
                'units': units_sorted
            })
        return render_template('books_vocab.html', books=books_payload)
    except Exception as e:
        logger.exception('خطا در واکشی کتاب‌ها')
        return render_template('books_vocab.html', books=[])

# مسیر قدیمی برای سازگاری؛ ریدایرکت به آدرس جدید
@app.route('/books')
def books_legacy_redirect():
    return redirect(url_for('books_page'), code=302)

@app.route('/books_vocab/<int:book_id>/quiz')
def start_book_quiz(book_id: int):
    """Start a quiz for a selected book by loading all its questions in random order.
    Reuses quiz.html and passes normalized question payloads that static/js/quiz.js can render.
    """
    try:
        book = Book.query.filter_by(id=book_id, is_active=True).first()
        if not book:
            return f"کتاب پیدا نشد", 404

        # فیلتر بر اساس یونیت اگر query param وجود داشته باشد
        unit_param = request.args.get('unit', '').strip()
        qtype_param = (request.args.get('qtype', '') or '').strip().lower()
        per_unit_raw = (request.args.get('per_unit', '20') or '20').strip().lower()
        per_unit = None if per_unit_raw == 'all' else int(per_unit_raw) if per_unit_raw.isdigit() else 20

        query = BookQuestion.query.filter_by(book_id=book_id)
        if unit_param:
            # اگر unit ارسال شده باشد فقط همان واحد را بگیر
            query = query.filter(BookQuestion.unit_number == unit_param)
        else:
            # اگر همه بود، به ترتیب شماره یونیت سورت کن (پیشفرض)
            try:
                from sqlalchemy import text
                query = query.order_by(text('CAST(unit_number AS UNSIGNED) ASC'))
            except Exception:
                query = query.order_by(BookQuestion.unit_number.asc())

        # فیلتر بر اساس نوع سوال در صورت نیاز
        if qtype_param == 'matching':
            query = query.filter(BookQuestion.question_type.ilike('%match%'))
        elif qtype_param == 'mcq':
            # چهار گزینه ای
            query = query.filter(BookQuestion.question_type.ilike('%choice%'))
        elif qtype_param == 'gapfill':
            query = query.filter(BookQuestion.question_type.in_(['gapfill','fill_blank','fill','blank']))

        # برای جلوگیری از تکرار نتایج در سرور: اگر نوع مشخص شده باشد، دقیقا در سطح دیتابیس رندوم کن
        # MySQL: ORDER BY RAND()
        if qtype_param in ('matching', 'mcq', 'gapfill'):
            try:
                query = query.order_by(func.rand())
            except Exception:
                pass

        questions = query.all()
        # همچنان یک شافل سبک در سطح برنامه برای اطمینان از تنوع
        try:
            random.shuffle(questions)
        except Exception:
            pass
        if not questions:
            # Render with empty questions, frontend will show a friendly message
            return render_template('quiz.html', title=f"{book.title}" , initial_quiz_questions_json=json.dumps([]))

        # زیرمجموعه‌گیری بر اساس تعداد سوال هر درس
        if per_unit is not None and not unit_param:
            # اگر unit مشخص نباشد و per_unit محدود باشد، از هر یونیت per_unit سوال انتخاب کن
            from collections import defaultdict
            unit_questions = defaultdict(list)
            for q in questions:
                unit_questions[q.unit_number].append(q)
            
            # مرتب‌سازی یونیت‌ها بر اساس شماره
            def unit_sort_key(val):
                try:
                    return (0, int(val))
                except:
                    return (1, str(val))
            
            sorted_units = sorted(unit_questions.keys(), key=unit_sort_key)
            questions = []
            for unit in sorted_units:
                unit_qs = unit_questions[unit]
                # شافل سوالات هر یونیت
                random.shuffle(unit_qs)
                # انتخاب حداکثر per_unit سوال از هر یونیت
                questions.extend(unit_qs[:per_unit])
        elif per_unit is not None and unit_param:
            # اگر unit مشخص باشد، فقط از آن یونیت per_unit سوال انتخاب کن
            questions = questions[:per_unit]

        formatted_questions = []
        for q in questions:
            # ساخت عنوان نمایشی با قالب «کتاب - درس N» در صورت وجود unit
            display_unit = str(q.unit_number).strip() if getattr(q, 'unit_number', None) is not None else ''
            content_label = f"درس {display_unit} - {book.title}" if display_unit else f"{book.title}"

            base = {
                "id": q.id,
                "type": (q.question_type or '').strip().lower(),
                "text": q.question_text,
                "fa_explanation": getattr(q, 'fa_explanation', None),
                "kur_explanation": getattr(q, 'kur_explanation', None),
                "eng_explanation": getattr(q, 'eng_explanation', None),
                # Provide a content-like label so existing code can show a quiz name when needed
                "content": content_label
            }
            q_type_norm = (q.question_type or '').strip().lower()
            is_gapfill = q_type_norm in { 'gapfill', 'gap', 'fillblank', 'fill-in-the-blank', 'fill', 'blank', 'fill_blank', 'fill blank', 'جای خالی' }

            # Always try matching first by data presence
            pairs = BookMatching.query.filter_by(book_question_id=q.id).all()
            try:
                logger.info(f"BookQuestion id=%s type=%s pairs=%s", q.id, (q.question_type or ''), len(pairs))
            except Exception:
                pass
            if pairs:
                formatted_pairs = [{"left": p.left_item, "right": p.right_item} for p in pairs]
                formatted_questions.append({**base, "type": "matching", "pairs": formatted_pairs})
                continue

            if is_gapfill:
                formatted_questions.append({**base, "type": "gapfill", "gap_answer": (q.correct_answer or "")})
            else:
                # Default to MCQ if not matching/gapfill
                options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt]
                correct_answer_text = q.correct_answer
                if q.correct_answer in ("option1", "option2", "option3", "option4"):
                    mapping = {
                        "option1": q.option1,
                        "option2": q.option2,
                        "option3": q.option3,
                        "option4": q.option4,
                    }
                    correct_answer_text = mapping.get(q.correct_answer) or q.correct_answer
                formatted_questions.append({**base, "type": "mcq", "options": options, "answer": correct_answer_text})

        response = make_response(render_template('quiz.html', title=f"{book.title}", initial_quiz_questions_json=json.dumps(formatted_questions)))
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        return response
    except Exception as e:
        logger.exception('Error starting book quiz')
        return f"خطا در بارگذاری سوالات کتاب: {e}", 500


@app.route('/api/translate', methods=['POST'])
def api_translate():
    """Translate small texts to Persian on demand for gap-fill hints.
    Expects JSON: { text: "word or phrase", target: "fa" }
    """
    try:
        data = request.get_json(silent=True) or {}
        text = str(data.get('text', '')).strip()
        target = str(data.get('target', 'fa')).strip().lower() or 'fa'
        # map custom codes
        if target in ('ku','ckb','sorani','kurdish','kurdish_sorani'):
            target = 'ckb'
        if not text:
            return jsonify({ 'success': False, 'error': 'empty_text' }), 400
        translated = translate_text_to(text, target)
        return jsonify({ 'success': True, 'translated': translated })
    except Exception as e:
        logger.exception('translate api error')
        return jsonify({ 'success': False, 'error': str(e) }), 500

@app.route('/grammar_tests')
def grammar_tests():
    """
    صفحه انتخاب آزمون را به صورت گروه بندی شده نمایش می دهد.
    مباحث (content) از دیتابیس واکشی و به صورت کاملا پویا گروه بندی می شوند.
    """
    try:
        # واکشی content و order_num از questions
        questions = Question.query.with_entities(Question.content, Question.order_num).order_by(Question.order_num).all()
        all_contents_raw = []
        content_order_map = {}
        content_details_map = {}
        for item in questions:
            if item.content:
                content_name = item.content.strip().title()
                all_contents_raw.append(content_name)
                if item.order_num is not None:
                    content_order_map[content_name] = item.order_num
        unique_contents = sorted(list(set(all_contents_raw)))
        from collections import defaultdict
        grouped_contents = defaultdict(list)
        main_categories_found = set()
        for content in unique_contents:
            if '(' not in content:
                main_categories_found.add(content)
                grouped_contents[content].append(content)
            else:
                match = re.match(r'^(.*?)\s*\(.*?\)$', content)
                if match:
                    base_name = match.group(1).strip()
                    if base_name not in main_categories_found:
                        main_categories_found.add(base_name)
                        grouped_contents[base_name].append(base_name)
        sorted_main_categories = sorted(list(main_categories_found), key=lambda x: content_order_map.get(x, float('inf')))
        for content in unique_contents:
            if '(' in content:
                match = re.match(r'^(.*?)\s*\(.*?\)$', content)
                if match:
                    base_name = match.group(1).strip()
                    if base_name in sorted_main_categories:
                        if content not in grouped_contents[base_name]:
                            grouped_contents[base_name].append(content)
                    else:
                        if content not in grouped_contents[content]:
                            grouped_contents[content].append(content)
                else:
                    if content not in grouped_contents[content]:
                        grouped_contents[content].append(content)
            else:
                pass
        final_grouped_tenses = defaultdict(list)
        for cat in sorted_main_categories:
            if cat in grouped_contents:
                final_grouped_tenses[cat].extend(grouped_contents[cat])
        for content in unique_contents:
            is_grouped = False
            for main_cat in sorted_main_categories:
                if content.startswith(main_cat):
                    is_grouped = True
                    break
            if not is_grouped and '(' not in content:
                if content not in final_grouped_tenses:
                    final_grouped_tenses[content].append(content)
            elif not is_grouped and '(' in content:
                match = re.match(r'^(.*?)\s*\(.*?\)$', content)
                if match:
                    base_name_for_sub = match.group(1).strip()
                    if base_name_for_sub not in final_grouped_tenses:
                        final_grouped_tenses[content].append(content)
                    elif content not in final_grouped_tenses[base_name_for_sub]:
                        final_grouped_tenses[base_name_for_sub].append(content)
                else:
                    final_grouped_tenses[content].append(content)
        for key in final_grouped_tenses:
            final_grouped_tenses[key] = sorted(list(set(final_grouped_tenses[key])))
        return render_template('grammar_test.html', grouped_tenses=final_grouped_tenses, content_details={})
    except Exception as e:
        print(f"Error in grammar_tests: {e}")
        return f"Error connecting to database: {e}", 500
@app.route('/tests')
def tests_legacy_redirect():
    return redirect(url_for('grammar_tests'), code=302)

@app.route('/test/<path:content_name>')
def run_test(content_name):
    try:
        decoded_content = unquote(content_name).strip().lower()
        
        # بررسی آزمون ترکیبی
        if decoded_content == 'combined':
            # برای آزمون ترکیبی، سوالات از sessionStorage بارگذاری می‌شوند
            # بنابراین فقط صفحه quiz را رندر می‌کنیم
            return render_template('quiz.html', title="آزمون ترکیبی")
        
        # آزمون عادی:
        all_questions = Question.query.filter(
            func.lower(Question.content) == decoded_content
        ).order_by(func.random()).limit(20).all()
        selected_questions = all_questions
        formatted_questions = []
        for q in selected_questions:
            options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt is not None]
            # تبدیل نام گزینه به متن کامل گزینه
            correct_answer_text = ""
            if q.correct_answer == "option1" and q.option1:
                correct_answer_text = q.option1
            elif q.correct_answer == "option2" and q.option2:
                correct_answer_text = q.option2
            elif q.correct_answer == "option3" and q.option3:
                correct_answer_text = q.option3
            elif q.correct_answer == "option4" and q.option4:
                correct_answer_text = q.option4
            else:
                # اگر نام گزینه نبود، همان متن اصلی را استفاده کن
                correct_answer_text = q.correct_answer
            
            formatted_q = {
                "id": q.id, "text": q.question_text,
                "options": options, "answer": correct_answer_text,
                "fa_explanation": getattr(q, "fa_explanation", None),
                "kur_explanation": getattr(q, "kur_explanation", None)
            }
            formatted_questions.append(formatted_q)
        response = make_response(render_template('quiz.html', title=decoded_content, initial_quiz_questions_json=json.dumps(formatted_questions)))
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        return response
    except Exception as e:
        print(f"Error in run_test: {e}")
        return f"Error fetching quiz data: {e}", 500


@app.route('/api/get-personalized-quiz', methods=['POST'])
def get_personalized_quiz():
    data = request.get_json()
    code = data.get('code')
    if not code:
        return jsonify({"success": False, "message": "کد تمرین الزامی است."}), 400
    try:
        # واکشی همه سوالات با کد داده شده
        all_personalized_questions = StudentQuiz.query.filter_by(code=code).all()
        if not all_personalized_questions:
            return jsonify({"success": False, "message": "سوالی یافت نو."}), 404

        # گروه‌بندی بر اساس unit
        from collections import defaultdict
        unit_map = defaultdict(list)
        for q in all_personalized_questions:
            unit_map[q.unit].append(q)
        # ترتیب یونیت‌ها: ابتدا مقادیر عددی به صورت صعودی، سپس سایر مقادیر به صورت حروفی
        def unit_sort_key(value):
            try:
                # تلاش برای مرتب‌سازی عددی
                return (0, float(value))
            except Exception:
                # مقادیر غیرعددی یا خالی
                safe_text = (value or '').strip()
                return (1, safe_text)

        sorted_units = sorted(unit_map.keys(), key=unit_sort_key)
        final_questions = []
        for unit in sorted_units:
            questions_in_unit = unit_map[unit]
            questions_in_unit_list = StudentQuiz.query.filter_by(code=code, unit=unit).order_by(func.random()).limit(15).all()
            selected = list(questions_in_unit_list)
            final_questions.extend(selected)
        # فرمت خروجی
        formatted_questions = []
        # print([getattr(q, 'content', None) for q in final_questions])
        for q in final_questions:
            options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt is not None]
            # تبدیل نام گزینه به متن کامل گزینه
            correct_answer_text = ""
            if q.correct_answer == "option1" and q.option1:
                correct_answer_text = q.option1
            elif q.correct_answer == "option2" and q.option2:
                correct_answer_text = q.option2
            elif q.correct_answer == "option3" and q.option3:
                correct_answer_text = q.option3
            elif q.correct_answer == "option4" and q.option4:
                correct_answer_text = q.option4
            else:
                # اگر نام گزینه نبود، همان متن اصلی را استفاده کن
                correct_answer_text = q.correct_answer
            
            formatted_q = {
                "id": q.id, "text": q.question_text,
                "options": options, "answer": correct_answer_text,
                "content": getattr(q, "content", None),
                "code": q.code,  # اضافه کردن کد سوال
                "fa_explanation": getattr(q, "fa_explanation", None),
                "kur_explanation": getattr(q, "kur_explanation", None)
            }
            formatted_questions.append(formatted_q)
        # print('DEBUG: formatted_questions =', formatted_questions)  # DEBUG: نمایش خروجی نهایی سوالات
        # تعیین عنوان آزمون بر اساس content
        if final_questions:
            unique_contents = list({q.content for q in final_questions if q.content})
            if len(unique_contents) == 1:
                quiz_title = unique_contents[0]
            else:
                quiz_title = '، '.join(unique_contents)
        else:
            quiz_title = "آزمون شخصی"
        response = jsonify({"success": True, "questions": formatted_questions, "title": quiz_title})
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        return response
    except Exception as e:
        logger.exception("خطا در get_personalized_quiz")
        return jsonify({"success": False, "message": "خطای سرور"}), 500


@app.route('/run-personalized-quiz-from-js')
def run_personalized_quiz_page():
    return render_template('quiz.html', title="در حال بارگذاری آزمون شخصی...")


@app.route('/api/get-available-grammars')
def get_available_grammars():
    """
    API برای دریافت لیست گرامرهای موجود با order_num
    """
    try:
        # دریافت تمام content های منحصر به فرد با order_num
        grammars = db.session.query(Question.content, Question.order_num).filter(
            Question.content.isnot(None)
        ).distinct().order_by(Question.order_num).all()
        
        formatted_grammars = []
        for grammar, order_num in grammars:
            if grammar and grammar.strip():
                formatted_grammars.append({
                    'name': grammar.strip(),
                    'order_num': order_num if order_num is not None else 999
                })
        
        return jsonify({
            "success": True,
            "grammars": formatted_grammars
        })
        
    except Exception as e:
        logger.exception("خطا در get_available_grammars")
        return jsonify({"success": False, "message": "خطای سرور"}), 500


@app.route('/api/get-combined-test', methods=['POST'])
def get_combined_test():
    """
    API برای دریافت سوالات آزمون ترکیبی از چندین گرامر مختلف
    """
    try:
        data = request.get_json()
        grammars = data.get('grammars', [])
        test_type = data.get('test_type', 'combined')
        order_mode = data.get('order_mode', 'grammar')  # 'grammar' | 'random'
        
        if not grammars:
            return jsonify({"success": False, "message": "هیچ گرامری انتخاب نشده است."}), 400
        
        # تعداد سوالات برای هر گرامر (20 سوال از هر گرامر)
        questions_per_grammar = 20
        
        all_questions = []
        
        for grammar in grammars:
            # دریافت سوالات برای هر گرامر (به صورت شانسی برای تنوع اولیه)
            # MySQL → RAND(), سایرین → random()
            base_q = Question.query.filter(
                func.lower(Question.content) == grammar.lower()
            )
            try:
                base_q = base_q.order_by(func.rand())
            except Exception:
                base_q = base_q.order_by(func.random())
            grammar_questions = base_q.limit(questions_per_grammar).all()
            all_questions.extend(grammar_questions)
        
        # ترتیب نهایی: اگر حالت 'grammar' انتخاب شده بود، بر اساس order_num؛ اگر 'random' بود، بدون مرتب‌سازی (یا دوباره تصادفی)
        if order_mode == 'grammar':
            all_questions.sort(key=lambda q: q.order_num if q.order_num is not None else float('inf'))
        else:
            # shuffle برای اطمینان از تصادفی بودن نهایی
            random.shuffle(all_questions)
        
        # استفاده از تمام سوالات (بدون محدودیت)
        selected_questions = all_questions
        
        # فرمت کردن سوالات
        formatted_questions = []
        for q in selected_questions:
            options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt is not None]
            
            # تبدیل نام گزینه به متن کامل گزینه
            correct_answer_text = ""
            if q.correct_answer == "option1" and q.option1:
                correct_answer_text = q.option1
            elif q.correct_answer == "option2" and q.option2:
                correct_answer_text = q.option2
            elif q.correct_answer == "option3" and q.option3:
                correct_answer_text = q.option3
            elif q.correct_answer == "option4" and q.option4:
                correct_answer_text = q.option4
            else:
                correct_answer_text = q.correct_answer
            
            formatted_q = {
                "id": q.id,
                "text": q.question_text,
                "options": options,
                "answer": correct_answer_text,
                "content": q.content,
                "fa_explanation": q.fa_explanation,
                "kur_explanation": q.kur_explanation
            }
            formatted_questions.append(formatted_q)
        
        # ایجاد عنوان آزمون ترکیبی
        total_questions_count = len(formatted_questions)
        quiz_title = f"آزمون ترکیبی: {', '.join(grammars[:3])}"
        if len(grammars) > 3:
            quiz_title += f" و {len(grammars) - 3} گرامر دیگر"
        quiz_title += f" ({total_questions_count} سوال)"
        
        response = jsonify({
            "success": True,
            "questions": formatted_questions,
            "title": quiz_title,
            "selected_grammars": grammars,
            "total_questions": len(formatted_questions),
            "order_mode": order_mode
        })
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        return response
        
    except Exception as e:
        logger.exception("خطا در get_combined_test")
        return jsonify({"success": False, "message": "خطای سرور"}), 500





@app.route('/api/save-result', methods=['POST'])
def save_result():
    data = request.get_json()
    # اگر کاربر لاگین است، همیشه نام جلسه را ذخیره کن حتی اگر فرانت نامی ارسال کند
    if 'uid' in session and session.get('uname'):
        user_name = session.get('uname')
    else:
        user_name = data.get('user_name') or 'کاربر ناشناس'
    quiz_name = data.get('quiz_name')
    score = data.get('score')
    total_questions = data.get('total_questions')
    public = data.get('public', True)  # پیش‌فرض True برای سازگاری
    selected_grammars = data.get('selected_grammars')  # گرامرهای انتخاب شده برای آزمون ترکیبی
    try:
        new_result = Result(
            user_name=user_name, 
            quiz_name=quiz_name, 
            score=score, 
            total_questions=total_questions, 
            created_at=datetime.now(),
            public=public,
            selected_grammars=selected_grammars
        )
        db.session.add(new_result)
        db.session.commit()
        # ذخیره جزئیات پاسخ‌ها اگر ارسال شده باشد
        items = data.get('items') or []
        if isinstance(items, list) and items:
            for it in items:
                try:
                    ri = ResultItem(
                        result_id=new_result.id,
                        question_id=it.get('id'),
                        question_type=it.get('type') or it.get('question_type'),
                        question_text=it.get('text') or it.get('question_text'),
                        options=it.get('options'),
                        user_answer=it.get('user_answer'),
                        correct_answer=it.get('answer') or it.get('correct_answer'),
                        is_correct=bool(it.get('is_correct')),
                        fa_explanation=it.get('fa_explanation'),
                        kur_explanation=it.get('kur_explanation'),
                        eng_explanation=it.get('eng_explanation')
                    )
                    db.session.add(ri)
                except Exception:
                    continue
            db.session.commit()
        return jsonify({"success": True, "result_id": new_result.id})
    except Exception as e:
        print(f"Error in save_result: {e}")
        return jsonify({"success": False, "message": str(e)}), 500


@app.route('/youtube')
def youtube_videos():
    return render_template('youtube.html')


@app.route('/page/<int:page_number>')
def show_page(page_number):
    return render_template('page_detail.html', number=page_number)


@app.route('/api/check-question-reported', methods=['POST'])
def check_question_reported():
    """بررسی اینکه آیا سوال قبلاً گزارش شده است"""
    try:
        data = request.get_json()
        question_id = data.get('question_id')
        
        if not question_id:
            return jsonify({"success": False, "message": "شناسه سوال الزامی است"}), 400
        
        # بررسی گزارش‌های قبلی (از همان IP در 24 ساعت گذشته)
        existing_report = WrongQuestion.query.filter(
            WrongQuestion.question_id == question_id,
            WrongQuestion.user_ip == request.remote_addr,
            WrongQuestion.created_at >= datetime.utcnow() - timedelta(hours=24)
        ).first()
        
        if existing_report:
            return jsonify({
                "success": True, 
                "reported": True, 
                "message": "به زودی سوال را ویرایش میکنیم:)",
                "report_date": existing_report.created_at.isoformat() if existing_report.created_at else None
            })
        else:
            return jsonify({
                "success": True, 
                "reported": False, 
                "message": "سوال گزارش نشده است"
            })
            
    except Exception as e:
        print(f"Error in check_question_reported: {e}")
        return jsonify({"success": False, "message": f"خطا در بررسی گزارش: {str(e)}"}), 500

@app.route('/api/report-question', methods=['POST'])
def report_question():
    try:
        data = request.get_json()
        
        # اضافه کردن debug log کامل
        # print("=" * 50)
        # print("DEBUG: گزارش جدید دریافت شد")
        # print(f"DEBUG: تمام داده‌های دریافتی: {data}")
        # print(f"DEBUG: reported_reason = '{data.get('reported_reason')}'")
        # print(f"DEBUG: نوع reported_reason = {type(data.get('reported_reason'))}")
        # print("=" * 50)
        
        # اعتبارسنجی داده‌های ضروری
        required_fields = ['question_id', 'question_text', 'options', 'correct_answer']
        for field in required_fields:
            if field not in data:
                return jsonify({"success": False, "message": f"فیلد {field} الزامی است"}), 400
        
        # بررسی تکراری نبودن گزارش (از همان IP در 24 ساعت گذشته)
        existing_report = WrongQuestion.query.filter(
            WrongQuestion.question_id == data['question_id'],
            WrongQuestion.user_ip == request.remote_addr,
            WrongQuestion.created_at >= datetime.utcnow() - timedelta(hours=24)
        ).first()
        
        if existing_report:
            return jsonify({"success": False, "message": "به زودی سوال را ویرایش میکنیم:)"}), 400
        
        # بررسی محدودیت تعداد گزارش (حداکثر 50 گزارش در روز)
        recent_reports = WrongQuestion.query.filter(
            WrongQuestion.user_ip == request.remote_addr,
            WrongQuestion.created_at >= datetime.utcnow() - timedelta(days=1)
        ).count()
        
        if recent_reports >= 50:
            return jsonify({"success": False, "message": "تعداد گزارش‌های شما در این روز به حد مجاز رسیده است (حداکثر 50 گزارش در روز)"}), 429
        
        # ایجاد رکورد جدید
        wrong_question = WrongQuestion(
            question_id=data['question_id'],
            question_text=data['question_text'],
            options=data['options'],
            correct_answer=data['correct_answer'],
            user_ip=request.remote_addr,
            quiz_name=data.get('quiz_name', ''),
            content=data.get('content', ''),  # مقدار content دقیق سوال
            question_type=data.get('question_type', ''),  # مقدار دقیق question_type
            reported_reason=data.get('reported_reason', 'سایر'),  # دلیل گزارش
            user_name=data.get('user_name', ''),  # نام کاربر
            fa_explanation=data.get('fa_explanation') or None,
            kur_explanation=data.get('kur_explanation') or None,
            eng_explanation=data.get('eng_explanation') or None
        )
        
        db.session.add(wrong_question)
        db.session.commit()
        
        return jsonify({
            "success": True, 
            "message": "سوال گزارش شد ✅"
        })
        
    except Exception as e:
        db.session.rollback()
        logger.exception("Error in report_question")
        return jsonify({"success": False, "message": "خطا در ثبت گزارش"}), 500

@app.route('/test-report-api')
def test_report_api():
    """تست API گزارش برای دیباگ"""
    try:
        # تست اتصال به دیتابیس
        test_question = WrongQuestion.query.first()
        return jsonify({
            "success": True,
            "message": "اتصال به دیتابیس OK",
            "table_exists": True,
            "sample_data": "جدول موجود است"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"خطا در اتصال به دیتابیس: {str(e)}",
            "table_exists": False
        })

@app.route('/admin/login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if username in ADMIN_CREDENTIALS:
            admin_info = ADMIN_CREDENTIALS[username]
            password_hash = hashlib.sha256(password.encode()).hexdigest()
            
            if password_hash == admin_info['password_hash']:
                session['admin_logged_in'] = True
                session['admin_username'] = admin_info['name']
                return redirect(url_for('admin_dashboard'))
            else:
                return render_template('admin/login.html', error='رمز عبور اشتباه است')
        else:
            return render_template('admin/login.html', error='نام کاربری یافت نشد')
    
    return render_template('admin/login.html')

@app.route('/admin/logout')
def admin_logout():
    session.pop('admin_logged_in', None)
    session.pop('admin_username', None)
    return redirect(url_for('admin_login'))

@app.route('/admin')
@admin_required
def admin_dashboard():
    try:
        # محاسبه آمار
        total_reports = WrongQuestion.query.count()
        pending_reports = WrongQuestion.query.filter_by(status='pending').count()
        fixed_reports = WrongQuestion.query.filter_by(status='fixed').count()
        today_reports = WrongQuestion.query.filter(
            WrongQuestion.created_at >= datetime.utcnow().date()
        ).count()
        
        stats = {
            'total_reports': total_reports,
            'pending_reports': pending_reports,
            'fixed_reports': fixed_reports,
            'today_reports': today_reports
        }
        
        return render_template('admin/dashboard.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             stats=stats)
    except Exception as e:
        print(f"Error in admin_dashboard: {e}")
        return render_template('admin/dashboard.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             stats={'total_reports': 0, 'pending_reports': 0, 'fixed_reports': 0, 'today_reports': 0})

# --- حذف route و کدهای صفحه wrong_questions ---

@app.route('/api/admin/update-question-status', methods=['POST'])
@admin_required
def update_question_status():
    try:
        data = request.get_json()
        question_id = data.get('question_id')
        new_status = data.get('status')
        
        if not question_id or not new_status:
            return jsonify({"success": False, "message": "پارامترهای ضروری ارسال نشده"}), 400
        
        wrong_question = WrongQuestion.query.get(question_id)
        if not wrong_question:
            return jsonify({"success": False, "message": "گزارش یافت نشد"}), 404
        
        wrong_question.status = new_status
        db.session.commit()
        
        return jsonify({"success": True, "message": "وضعیت با موفقیت به‌روزرسانی شد"})
        
    except Exception as e:
        db.session.rollback()
        print(f"Error in update_question_status: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/admin/get-question/<int:report_id>')
@admin_required
def get_question_for_edit(report_id):
    try:
        # دریافت گزارش
        wrong_question = WrongQuestion.query.get(report_id)
        if not wrong_question:
            return jsonify({"success": False, "message": "گزارش یافت نشد"}), 404
        
        # تشخیص جدول اصلی
        if wrong_question.question_type == 'general':
            # سوال از جدول questions
            question = Question.query.get(wrong_question.question_id)
        else:
            # سوال از جدول student_quiz
            question = StudentQuiz.query.get(wrong_question.question_id)
        
        if not question:
            return jsonify({"success": False, "message": "سوال اصلی یافت نشد"}), 404
        
        # تبدیل به JSON
        question_data = {
            'id': question.id,
            'question_text': question.question_text,
            'option1': question.option1,
            'option2': question.option2,
            'option3': question.option3,
            'option4': question.option4,
            'correct_answer': question.correct_answer,
            'content': getattr(question, 'content', None),
            'unit': getattr(question, 'unit', None)
        }
        
        return jsonify({
            "success": True,
            "question": question_data
        })
        
    except Exception as e:
        print(f"Error in get_question_for_edit: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/admin/edit-question', methods=['POST'])
@admin_required
def edit_question():
    try:
        data = request.get_json()
        
        # اعتبارسنجی داده‌ها
        required_fields = ['question_id', 'question_type', 'question_text', 'option1', 'option2', 'option3', 'option4', 'correct_answer']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({"success": False, "message": f"فیلد {field} الزامی است"}), 400
        
        # بررسی اینکه پاسخ صحیح در گزینه‌ها باشد
        options = [data['option1'], data['option2'], data['option3'], data['option4']]
        if data['correct_answer'] not in ['option1', 'option2', 'option3', 'option4']:
            return jsonify({"success": False, "message": "پاسخ صحیح باید یکی از گزینه‌ها باشد"}), 400
        
        # تشخیص جدول اصلی و به‌روزرسانی
        if data['question_type'] == 'general':
            question = Question.query.get(data['question_id'])
        else:
            question = StudentQuiz.query.get(data['question_id'])
        
        if not question:
            return jsonify({"success": False, "message": "سوال یافت نشد"}), 404
        
        # به‌روزرسانی سوال
        question.question_text = data['question_text']
        question.option1 = data['option1']
        question.option2 = data['option2']
        question.option3 = data['option3']
        question.option4 = data['option4']
        question.correct_answer = data['correct_answer']
        
        # تغییر وضعیت گزارش به 'fixed'
        wrong_question = WrongQuestion.query.filter_by(question_id=data['question_id']).first()
        if wrong_question:
            wrong_question.status = 'fixed'
        
        db.session.commit()
        
        return jsonify({
            "success": True,
            "message": "سوال با موفقیت ویرایش شد"
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"Error in edit_question: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/debug/columns')
def debug_columns():
    inspector = inspect(db.engine)
    columns = inspector.get_columns('questions')
    col_names = [column['name'] for column in columns]
    return '<br>'.join(col_names)

@app.route('/debug/wrong-questions-columns')
def debug_wrong_questions_columns():
    inspector = inspect(db.engine)
    try:
        columns = inspector.get_columns('wrong_questions')
        col_names = [column['name'] for column in columns]
        return '<br>'.join(col_names)
    except Exception as e:
        return f"Error: {e}"

@app.route('/debug/text-values')
def debug_text_values():
    """تست text values فعلی"""
    try:
        # تست text values فارسی
        test_reasons = ['سوال اشتباهه!', 'پاسخ درست اشتباهه!', 'بیش از یک جواب درست!', 'سایر']
        results = []
        
        for reason in test_reasons:
            try:
                # تست insert موقت
                test_record = WrongQuestion(
                    question_id=999999,  # ID موقت
                    question_text="Test question",
                    options={"test": "data"},
                    correct_answer="test",
                    reported_reason=reason
                )
                db.session.add(test_record)
                db.session.commit()
                results.append(f"✅ {reason}: OK")
                # حذف رکورد تست
                db.session.delete(test_record)
                db.session.commit()
            except Exception as e:
                results.append(f"❌ {reason}: {str(e)}")
        
        return jsonify({
            "success": True,
            "text_test_results": results
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/debug/test-simple/<int:question_id>')
def debug_test_simple(question_id):
    """تست ساده برای یک سوال"""
    try:
        from sqlalchemy import text
        
        # فقط اطلاعات wrong_questions
        result = db.session.execute(text("SELECT * FROM wrong_questions WHERE id = :id"), {"id": question_id})
        row = result.fetchone()
        
        if row:
            return jsonify({
                'success': True,
                'data': dict(row._mapping)
            })
        else:
            return jsonify({
                'success': False,
                'message': 'سوال یافت نشد'
            })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        })

@app.route('/debug/test-db')
def debug_test_db():
    """تست اتصال دیتابیس"""
    try:
        # استفاده از SQLAlchemy به جای mysql.connection
        from sqlalchemy import text
        
        # تست جدول wrong_questions
        result = db.session.execute(text("SELECT COUNT(*) as count FROM wrong_questions"))
        wrong_questions_count = result.fetchone()[0]
        
        # تست جدول questions
        result = db.session.execute(text("SELECT COUNT(*) as count FROM questions"))
        questions_count = result.fetchone()[0]
        
        # تست جدول student_quiz
        result = db.session.execute(text("SELECT COUNT(*) as count FROM student_quiz"))
        student_quiz_count = result.fetchone()[0]
        
        # یک نمونه از wrong_questions
        result = db.session.execute(text("SELECT * FROM wrong_questions LIMIT 1"))
        sample_wrong_question = result.fetchone()
        
        return jsonify({
            'success': True,
            'wrong_questions_count': wrong_questions_count,
            'questions_count': questions_count,
            'student_quiz_count': student_quiz_count,
            'sample_wrong_question': dict(sample_wrong_question._mapping) if sample_wrong_question else None
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e),
            'error_type': type(e).__name__
        })

@app.route('/debug/reported-question/<int:question_id>')
def debug_reported_question(question_id):
    pass  # این route فعلاً غیرفعال شد چون فقط کد کامنت شده داشت و باعث خطای لاینتری می‌شد

@app.route('/debug/current-reports')
def debug_current_reports():
    """نمایش گزارشات فعلی برای debug"""
    try:
        reports = WrongQuestion.query.all()
        report_data = []
        
        for report in reports:
            report_data.append({
                'id': report.id,
                'question_text': report.question_text[:50] + '...',
                'reported_reason': report.reported_reason,
                'status': report.status,
                'created_at': report.created_at.isoformat() if report.created_at else None
            })
        
        return jsonify({
            "success": True,
            "total_reports": len(report_data),
            "reports": report_data
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/test-report-manual')
def test_report_manual():
    """تست دستی گزارش برای debug"""
    try:
        # تست با داده‌های نمونه
        test_data = {
            'question_id': 999,
            'question_text': 'سوال تست',
            'options': ['گزینه 1', 'گزینه 2', 'گزینه 3', 'گزینه 4'],
            'correct_answer': 'گزینه 1',
            'quiz_name': 'تست',
            'content': 'تست',
            'quiz_type': 'general',
            'reported_reason': 'سوال اشتباهه!'
        }
        
        # ایجاد رکورد تست
        wrong_question = WrongQuestion(
            question_id=test_data['question_id'],
            question_text=test_data['question_text'],
            options=test_data['options'],
            correct_answer=test_data['correct_answer'],
            user_ip='127.0.0.1',
            quiz_name=test_data['quiz_name'],
            content=test_data['content'],
            question_type=test_data['quiz_type'],
            reported_reason=test_data['reported_reason']
        )
        
        db.session.add(wrong_question)
        db.session.commit()
        
        return jsonify({
            "success": True,
            "message": "تست موفق بود",
            "inserted_reason": wrong_question.reported_reason
        })
        
    except Exception as e:
        db.session.rollback()
        return jsonify({
            "success": False,
            "error": str(e)
        })

@app.route('/results')
def show_results():
    try:
        # دریافت آخرین نتایج (50 مورد آخر)
        results = Result.query.order_by(Result.created_at.desc()).limit(50).all()
        
        # تبدیل به فرمت مناسب برای نمایش
        formatted_results = []
        for result in results:
            if result.created_at:
                try:
                    shamsi_date = jdatetime.datetime.fromgregorian(datetime=result.created_at).strftime('%Y/%m/%d %H:%M')
                except Exception:
                    shamsi_date = 'نامشخص'
            else:
                shamsi_date = 'نامشخص'
            # اگر گرامرهای انتخاب‌شده موجود است، نام آزمون را بر اساس آن بساز
            display_quiz_name = result.quiz_name or 'آزمون ناشناس'
            if result.selected_grammars and result.selected_grammars.strip():
                display_quiz_name = f"آزمون ترکیبی: {result.selected_grammars}"
            
            formatted_results.append({
                'id': result.id,
                'user_name': result.user_name or 'کاربر ناشناس',
                'quiz_name': display_quiz_name,
                'score': result.score,
                'total_questions': result.total_questions,
                'percentage': round((result.score / result.total_questions) * 100, 1) if result.total_questions > 0 else 0,
                'created_at': shamsi_date,
                'status': 'عالی' if result.score >= result.total_questions * 0.8 else 'خوب' if result.score >= result.total_questions * 0.6 else 'متوسط' if result.score >= result.total_questions * 0.4 else 'در حال پیشرفت'
            })
        
        return render_template('results.html', results=formatted_results)
    except Exception as e:
        print(f"Error in show_results: {e}")
        return render_template('results.html', results=[])

@app.route('/user_results')
def user_results():
    """
    صفحه تمام نتایج کاربران
    """
    try:
        # پشتیبانی از limit پویا: ?limit=1000 یا ?limit=all
        limit_param = (request.args.get('limit') or '').strip().lower()
        # مقدار پیش‌فرض صفحه‌بندی
        per_page = 50
        if limit_param == 'all':
            per_page = None
        elif limit_param:
            try:
                # سقف معقول برای جلوگیری از فشار سرور
                per_page = max(1, min(int(limit_param), 2000))
            except Exception:
                per_page = 50

        query = db.session.query(Result).filter(Result.public == True).order_by(Result.created_at.desc())
        # نرمال‌سازی شماره صفحه
        try:
            page = int(request.args.get('page', '1') or '1')
        except Exception:
            page = 1
        page = max(1, page)
        if per_page is not None:
            offset = (page - 1) * per_page
            query = query.limit(per_page).offset(offset)
        all_results = query.all()

        # محاسبه آمار صفحه‌بندی
        total_results = db.session.query(func.count(Result.id)).filter(Result.public == True).scalar() or 0
        if per_page is None:
            # وقتی limit=all یا مشخص نشده باشد، کل را نمایش می‌دهیم و تعداد صفحات 1 است
            total_pages = 1
            page = 1
            per_page_display = total_results or len(all_results)
        else:
            per_page_display = per_page
            total_pages = max(1, (total_results + per_page_display - 1) // per_page_display)
            page = max(1, min(page, total_pages))
        
        # تبدیل به فرمت مناسب برای نمایش
        formatted_results = []
        for result in all_results:
            if result.created_at:
                try:
                    shamsi_date = jdatetime.datetime.fromgregorian(datetime=result.created_at).strftime('%Y/%m/%d %H:%M')
                except Exception:
                    shamsi_date = 'نامشخص'
            else:
                shamsi_date = 'نامشخص'
            
            percentage = round((result.score / result.total_questions) * 100, 1) if result.total_questions > 0 else 0
            
            # تعیین وضعیت بر اساس درصد
            if percentage >= 95:
                status = 'عالی'
            elif percentage >= 90:
                status = 'خیلی خوب'
            elif percentage >= 85:
                status = 'خوب'
            elif percentage >= 80:
                status = 'قابل قبول'
            elif percentage >= 70:
                status = 'متوسط'
            elif percentage >= 60:
                status = 'ضعیف'
            else:
                status = 'خیلی ضعیف'
            
            # اگر گرامرهای انتخاب‌شده موجود است، نام آزمون را بر اساس آن بساز
            display_quiz_name = result.quiz_name or 'آزمون ناشناس'
            if result.selected_grammars and result.selected_grammars.strip():
                display_quiz_name = f"آزمون ترکیبی: {result.selected_grammars}"
            
            formatted_results.append({
                'id': result.id,
                'user_name': result.user_name or 'کاربر ناشناس',
                'quiz_name': display_quiz_name,
                'score': result.score,
                'total_questions': result.total_questions,
                'percentage': percentage,
                'created_at': shamsi_date,
                'status': status
            })
        
        # شماره شروع ردیف‌ها برای نمایش متوالی بین صفحات
        start_index = 1 if per_page_display in (0, None) else ((page - 1) * per_page_display) + 1
        return render_template('user_results.html', results=formatted_results, page=page, per_page=per_page_display, total_pages=total_pages, total_results=total_results, start_index=start_index)
    except Exception as e:
        print(f"Error in user_results: {e}")
        return render_template('user_results.html', results=[], page=1, per_page=0, total_pages=1, total_results=0, start_index=1)


@app.route('/api/user_results')
def api_user_results():
    """
    JSON endpoint برای نتایج کاربران با صفحه‌بندی و فیلتر/مرتب‌سازی
    Params:
      - page: شماره صفحه (1+)
      - limit: تعداد در هر صفحه (پیش‌فرض 50، max 2000). اگر 'all' → همه
      - sort: 'date' | 'top' | 'most'
      - search: متن جستجو در نام کاربر یا نام آزمون
    """
    try:
        # پارامترها
        sort = (request.args.get('sort') or 'date').strip().lower()
        search = (request.args.get('search') or '').strip()
        limit_param = (request.args.get('limit') or '').strip().lower()
        try:
            page = int(request.args.get('page', '1') or '1')
        except Exception:
            page = 1
        page = max(1, page)

        per_page = 50
        if limit_param == 'all':
            per_page = None
        elif limit_param:
            try:
                per_page = max(1, min(int(limit_param), 2000))
            except Exception:
                per_page = 50

        # فیلتر پایه
        base_filter = [Result.public == True]
        if search:
            like = f"%{search}%"
            base_filter.append(or_(Result.user_name.ilike(like), Result.quiz_name.ilike(like)))

        if sort == 'most':
            # تجمیع بر اساس نام کاربر
            count_expr = func.count(Result.id).label('c')
            q_total = db.session.query(func.count(func.distinct(Result.user_name))).filter(*base_filter)
            total_results = q_total.scalar() or 0
            total_pages = 1
            if per_page is not None:
                total_pages = max(1, (total_results + per_page - 1) // per_page)
            page = min(page, total_pages)
            query = db.session.query(Result.user_name.label('user_name'), count_expr).filter(*base_filter).group_by(Result.user_name).order_by(count_expr.desc())
            if per_page is not None:
                query = query.limit(per_page).offset((page - 1) * per_page)
            rows = query.all()
            items = [{ 'user_name': r.user_name or 'کاربر ناشناس', 'count': int(getattr(r, 'c', 0) or 0) } for r in rows]
            # مقادیر سه سطح برتر برای مدال‌ها
            # برای این منظور، اگر در همین صفحه در دسترس نبودند، یک کوئری کوتاه بگیریم
            top_counts = []
            try:
                all_counts = db.session.query(count_expr).filter(*base_filter).group_by(Result.user_name).order_by(count_expr.desc()).limit(50).all()
                for rc in all_counts:
                    val = int(getattr(rc, 'c', 0) or 0)
                    if val not in top_counts:
                        top_counts.append(val)
                    if len(top_counts) >= 3:
                        break
            except Exception:
                pass
            return jsonify({
                'success': True,
                'mode': 'most',
                'page': page,
                'per_page': per_page,
                'total_pages': total_pages,
                'total_results': total_results,
                'top_counts': top_counts,
                'items': items
            })

        # حالت عادی: ردیف نتایج
        q_total = db.session.query(func.count(Result.id)).filter(*base_filter)
        total_results = q_total.scalar() or 0
        if per_page is None:
            per_page = total_results or 1
        total_pages = max(1, (total_results + per_page - 1) // per_page)
        page = min(page, total_pages)

        query = db.session.query(Result).filter(*base_filter)
        if sort == 'top':
            # درصد = score/total_questions
            pct_expr = (Result.score * 1.0) / func.nullif(Result.total_questions, 0)
            query = query.order_by(pct_expr.desc(), Result.created_at.desc())
        else:
            # پیشفرض: تاریخ نزولی
            query = query.order_by(Result.created_at.desc())
        query = query.limit(per_page).offset((page - 1) * per_page)
        results = query.all()

        # ساخت JSON آیتم‌ها
        items = []
        for r in results:
            percentage = round((r.score / r.total_questions) * 100, 1) if getattr(r, 'total_questions', 0) else 0
            if getattr(r, 'created_at', None):
                try:
                    shamsi_date = jdatetime.datetime.fromgregorian(datetime=r.created_at).strftime('%Y/%m/%d %H:%M')
                except Exception:
                    shamsi_date = 'نامشخص'
            else:
                shamsi_date = 'نامشخص'
            items.append({
                'id': r.id,
                'user_name': r.user_name or 'کاربر ناشناس',
                'quiz_name': r.quiz_name or 'آزمون ناشناس',
                'score': r.score,
                'total_questions': r.total_questions,
                'percentage': percentage,
                'created_at': shamsi_date,
                'created_at_iso': r.created_at.isoformat() if getattr(r, 'created_at', None) else None
            })

        return jsonify({
            'success': True,
            'mode': 'list',
            'page': page,
            'per_page': per_page,
            'total_pages': total_pages,
            'total_results': total_results,
            'items': items
        })
    except Exception as e:
        logger.exception('api_user_results error')
        return jsonify({ 'success': False, 'error': str(e) }), 500

@app.route('/test-ui')
def test_ui():
    """صفحه تست رابط کاربری"""
    return render_template('test_ui.html')

@app.route('/admin/reported_questions', endpoint='admin_reported_questions')
@admin_required
def admin_reported_questions():
    try:
        # دریافت همه گزارش‌ها با مرتب‌سازی بر اساس تاریخ
        reports = WrongQuestion.query.order_by(WrongQuestion.created_at.desc()).all()
        
        return render_template('admin/reported_questions.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             reports=reports)
    except Exception as e:
        print(f"Error in admin_reported_questions: {e}")
        return render_template('admin/reported_questions.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             reports=[])

@app.route('/api/reported-questions/edit/<int:question_id>', methods=['GET'])
def get_reported_question(question_id):
    """دریافت اطلاعات کامل سوال گزارش شده"""
    try:
        from sqlalchemy import text
        
        # ابتدا اطلاعات سوال گزارش شده را دریافت کن
        result = db.session.execute(text("SELECT * FROM wrong_questions WHERE id = :id"), {"id": question_id})
        reported_question = result.fetchone()
        
        if not reported_question:
            return jsonify({'success': False, 'message': 'سوال یافت نشد'})
        
        reported_question = dict(reported_question._mapping)
        question_id_in_table = reported_question['question_id']
        question_type = reported_question.get('question_type', '')
        
        # print(f"Debug: question_id={question_id}, question_id_in_table={question_id_in_table}, question_type='{question_type}'")
        
        # ابتدا از جدول questions جستجو کن
        result = db.session.execute(text("SELECT * FROM questions WHERE id = :id"), {"id": question_id_in_table})
        question_data = result.fetchone()
        source_table = 'questions'
        
        # اگر در questions پیدا نشد، از student_quiz جستجو کن
        if not question_data:
            result = db.session.execute(text("SELECT * FROM student_quiz WHERE id = :id"), {"id": question_id_in_table})
            question_data = result.fetchone()
            source_table = 'student_quiz' if question_data else 'questions'
        
        # اگر در student_quiz هم پیدا نشد، از book_questions جستجو کن
        if not question_data:
            result = db.session.execute(text("SELECT * FROM book_questions WHERE id = :id"), {"id": question_id_in_table})
            question_data = result.fetchone()
            source_table = 'book_questions' if question_data else 'questions'
        
        if not question_data:
            return jsonify({'success': False, 'message': 'سوال اصلی یافت نشد'})
        
        question_data = dict(question_data._mapping)
        # print(f"Debug: Found in {source_table}")
        
        # اگر سؤال از book_questions است، جفت‌های مچینگ را هم دریافت کن
        pairs_data = []
        if source_table == 'book_questions':
            pairs_result = db.session.execute(text("SELECT left_item, right_item FROM book_matching WHERE book_question_id = :id"), {"id": question_id_in_table})
            pairs_data = [{"left": row.left_item, "right": row.right_item} for row in pairs_result]
        
        return jsonify({
            'success': True,
            'question': {
                'question_text': question_data.get('question_text', ''),
                'option1': question_data.get('option1', ''),
                'option2': question_data.get('option2', ''),
                'option3': question_data.get('option3', ''),
                'option4': question_data.get('option4', ''),
                'correct_answer': question_data.get('correct_answer', 'A'),
                'content': question_data.get('content', ''),
                'unit': question_data.get('unit', ''),
                'order_num': question_data.get('order_num', ''),
                'pairs': pairs_data,  # برای سؤالات مچینگ
                'question_type': question_data.get('question_type', ''),  # نوع سؤال
                'fa_explanation': question_data.get('fa_explanation', ''),
                'kur_explanation': question_data.get('kur_explanation', ''),
                'eng_explanation': question_data.get('eng_explanation', '')
            },
            'source_table': source_table
        })
        
    except Exception as e:
        print(f"Error in get_reported_question: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'message': str(e)})

@app.route('/api/reported-questions/edit/<int:question_id>', methods=['POST'])
def edit_reported_question(question_id):
    """ویرایش سوال گزارش شده"""
    try:
        data = request.get_json()
        user_ip = request.remote_addr
        
        # بررسی محدودیت تعداد ویرایش در روز (حداکثر 20 ویرایش در روز)
        today = datetime.utcnow().date()
        today_edits = db.session.query(func.count(WrongQuestion.id)).filter(
            WrongQuestion.user_ip == user_ip,
            func.date(WrongQuestion.created_at) == today,
            WrongQuestion.status == 'fixed'
        ).scalar()
        
        if today_edits >= 20:
            return jsonify({
                'success': False,
                'message': 'شما امروز بیش از حد مجاز سوال ویرایش کرده‌اید.'
            }), 429
        
        from sqlalchemy import text
        
        # ابتدا اطلاعات سوال گزارش شده را دریافت کن
        result = db.session.execute(text("SELECT * FROM wrong_questions WHERE id = :id"), {"id": question_id})
        reported_question = result.fetchone()
        
        if not reported_question:
            return jsonify({
                'success': False,
                'message': 'سوال مورد نظر یافت نشد.'
            }), 404
        
        reported_question = dict(reported_question._mapping)
        question_id_in_table = reported_question['question_id']
        question_type = reported_question.get('question_type', '')

        # ابتدا از جدول questions جستجو کن
        result = db.session.execute(text("SELECT * FROM questions WHERE id = :id"), {"id": question_id_in_table})
        question_data = result.fetchone()
        source_table = 'questions'

        # اگر در questions پیدا نشد، از student_quiz جستجو کن
        if not question_data:
            result = db.session.execute(text("SELECT * FROM student_quiz WHERE id = :id"), {"id": question_id_in_table})
            question_data = result.fetchone()
            source_table = 'student_quiz' if question_data else 'questions'
        
        # اگر در student_quiz هم پیدا نشد، از book_questions جستجو کن
        if not question_data:
            result = db.session.execute(text("SELECT * FROM book_questions WHERE id = :id"), {"id": question_id_in_table})
            question_data = result.fetchone()
            source_table = 'book_questions' if question_data else 'questions'
        
        # بروزرسانی سوال در جدول اصلی
        if source_table == 'questions':
            db.session.execute(text("""
                UPDATE questions SET 
                    question_text = :question_text,
                    option1 = :option1,
                    option2 = :option2,
                    option3 = :option3,
                    option4 = :option4,
                    correct_answer = :correct_answer,
                    content = :content,
                    order_num = :order_num
                WHERE id = :id
            """), {
                'question_text': data.get('question_text', '') or '',
                'option1': data.get('option1', '') or '',
                'option2': data.get('option2', '') or '',
                'option3': data.get('option3', '') or '',
                'option4': data.get('option4', '') or '',
                'correct_answer': data.get('correct_answer', 'option1') or 'option1',
                'content': data.get('content', '') or '',
                'order_num': data.get('order_num', 0) if data.get('order_num', None) is not None else 0,
                'id': question_id_in_table
            })
            # همچنین مقدار جدید content را در جدول wrong_questions نیز آپدیت کن
            db.session.execute(text("""
                UPDATE wrong_questions SET quiz_name = :quiz_name WHERE question_id = :question_id
            """), {
                'quiz_name': data.get('content', '') or '',
                'question_id': question_id_in_table
            })
        elif source_table == 'student_quiz':
            db.session.execute(text("""
                UPDATE student_quiz SET 
                    question_text = :question_text,
                    option1 = :option1,
                    option2 = :option2,
                    option3 = :option3,
                    option4 = :option4,
                    correct_answer = :correct_answer,
                    content = :content,
                    unit = :unit,
                    code = :code
                WHERE id = :id
            """), {
                'question_text': data.get('question_text', '') or '',
                'option1': data.get('option1', '') or '',
                'option2': data.get('option2', '') or '',
                'option3': data.get('option3', '') or '',
                'option4': data.get('option4', '') or '',
                'correct_answer': data.get('correct_answer', 'A') or 'A',
                'content': data.get('content', '') or '',
                'unit': data.get('unit', ''),
                'code': data.get('quiz_name', ''),
                'id': question_id_in_table
            })
            # همچنین مقدار جدید code را در جدول wrong_questions نیز آپدیت کن
            db.session.execute(text("""
                UPDATE wrong_questions SET quiz_name = :quiz_name WHERE question_id = :question_id
            """), {
                'quiz_name': data.get('quiz_name', ''),
                'question_id': question_id_in_table
            })
        elif source_table == 'book_questions':
            # تشخیص نوع: matching / gap-fill / mcq
            pairs = data.get('pairs', []) or []
            has_pairs = isinstance(pairs, list) and len(pairs) > 0
            raw_gap = data.get('gap_answer', None)
            gap_answer = (raw_gap.strip() if isinstance(raw_gap, str) else raw_gap)

            if has_pairs:
                # فقط متن سؤال را بروزرسانی کن؛ گزینه‌ها را دست نمی‌زنیم
                db.session.execute(text("""
                    UPDATE book_questions SET 
                        question_text = :question_text,
                        fa_explanation = :fa_exp,
                        kur_explanation = :kur_exp,
                        eng_explanation = :eng_exp
                    WHERE id = :id
                """), {
                    'question_text': data.get('question_text', '') or '',
                    'fa_exp': data.get('fa_explanation', None),
                    'kur_exp': data.get('kur_explanation', None),
                    'eng_exp': data.get('eng_explanation', None),
                    'id': question_id_in_table
                })
                # جایگزینی جفت‌ها
                db.session.execute(text("DELETE FROM book_matching WHERE book_question_id = :id"), { 'id': question_id_in_table })
                for pair in pairs:
                    left_item = (pair.get('left') or '').strip()
                    right_item = (pair.get('right') or '').strip()
                    if left_item or right_item:
                        db.session.execute(
                            text("""
                                INSERT INTO book_matching (book_question_id, left_item, right_item)
                                VALUES (:qid, :left_item, :right_item)
                            """),
                            { 'qid': question_id_in_table, 'left_item': left_item, 'right_item': right_item }
                        )
            elif gap_answer is not None and str(gap_answer) != '':
                # Gap-fill: متن و پاسخ جای‌خالی را بروزرسانی کن
                db.session.execute(text("""
                    UPDATE book_questions SET 
                        question_text = :question_text,
                        correct_answer = :gap_answer,
                        fa_explanation = :fa_exp,
                        kur_explanation = :kur_exp,
                        eng_explanation = :eng_exp
                    WHERE id = :id
                """), {
                    'question_text': data.get('question_text', '') or '',
                    'gap_answer': gap_answer,
                    'fa_exp': data.get('fa_explanation', None),
                    'kur_exp': data.get('kur_explanation', None),
                    'eng_exp': data.get('eng_explanation', None),
                    'id': question_id_in_table
                })
            else:
                # MCQ: گزینه‌ها و پاسخ صحیح (option1/2/3/4) بروزرسانی شوند
                db.session.execute(text("""
                    UPDATE book_questions SET 
                        question_text = :question_text,
                        option1 = :option1,
                        option2 = :option2,
                        option3 = :option3,
                        option4 = :option4,
                        correct_answer = :mcq_correct,
                        fa_explanation = :fa_exp,
                        kur_explanation = :kur_exp,
                        eng_explanation = :eng_exp
                    WHERE id = :id
                """), {
                    'question_text': data.get('question_text', '') or '',
                    'option1': data.get('option1', '') or '',
                    'option2': data.get('option2', '') or '',
                    'option3': data.get('option3', '') or '',
                    'option4': data.get('option4', '') or '',
                    'mcq_correct': data.get('correct_answer', 'option1') or 'option1',
                    'fa_exp': data.get('fa_explanation', None),
                    'kur_exp': data.get('kur_explanation', None),
                    'eng_exp': data.get('eng_explanation', None),
                    'id': question_id_in_table
            })
        
        # بروزرسانی وضعیت سوال گزارش شده
        db.session.execute(text("""
            UPDATE wrong_questions SET 
                status = 'fixed',
                question_text = :question_text
            WHERE id = :id
        """), {
            'question_text': data.get('question_text', ''),
            'id': question_id
        })
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'سوال با موفقیت ویرایش شد.'
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"Error in edit_reported_question: {e}")
        return jsonify({
            'success': False,
            'message': 'خطا در ویرایش سوال.'
        }), 500

@app.route('/api/reported-questions/reject/<int:question_id>', methods=['POST'])
def reject_reported_question(question_id):
    """رد کردن سوال گزارش شده"""
    try:
        user_ip = request.remote_addr
        
        # پیدا کردن سوال
        question = WrongQuestion.query.get(question_id)
        if not question:
            return jsonify({
                'success': False,
                'message': 'سوال مورد نظر یافت نشد.'
            }), 404
        
        # تغییر وضعیت به رد شده
        question.status = 'rejected'
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'سوال با موفقیت رد شد.'
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"Error in reject_reported_question: {e}")
        return jsonify({
            'success': False,
            'message': 'خطا در رد کردن سوال.'
        }), 500

@app.route('/api/reported-questions/delete/<int:question_id>', methods=['POST'])
def delete_reported_question(question_id):
    try:
        from sqlalchemy import text
        db.session.execute(text("DELETE FROM wrong_questions WHERE id = :id"), {"id": question_id})
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': str(e)})

@app.route('/article/<int:article_id>')
@app.route('/article/<int:article_id>/<lang>')
@app.route('/article/<int:article_id>/<slug>/<lang>')
def article_detail(article_id, slug=None, lang='fa'):
    # دریافت مقاله از دیتابیس
    article = Article.query.filter_by(id=article_id, is_published=True).first()
    
    if not article:
        return "مقاله یافت نشد", 404
    
    # افزایش تعداد بازدید
    article.views += 1
    db.session.commit()
    
    # دریافت بلاک‌های فعال مقاله
    blocks = article.blocks.filter_by(is_active=True).order_by(ArticleBlock.order_num).all()
    
    # انتخاب زبان (پیش‌فرض فارسی)
    if lang not in ['fa', 'ku', 'en']:
        lang = 'fa'
    
    # ایجاد slug از عنوان انگلیسی
    english_title = article.title_en or article.title_fa
    slug = create_slug(english_title)
    
    # تبدیل به فرمت مناسب برای template
    article_data = {
        'id': article.id,
        'lang': lang,
        'title': getattr(article, f'title_{lang}'),
        'slug': slug,
        'date': article.created_at.strftime('%Y-%m-%d'),
        'views': f"{article.views:,}",
        'tags': getattr(article, f'tags_{lang}').split(',') if getattr(article, f'tags_{lang}') else [],
        'blocks': blocks
    }
    
    return render_template('article_detail.html', article=article_data)

@app.route('/api/latest-articles')
@app.route('/api/latest-articles/<lang>')
def get_latest_articles(lang='fa'):
    """دریافت آخرین مقالات برای صفحه اصلی"""
    try:
        # انتخاب زبان (پیش‌فرض فارسی)
        if lang not in ['fa', 'ku', 'en']:
            lang = 'fa'
        
        # دریافت همه مقالات منتشر شده
        articles = Article.query.filter_by(is_published=True)\
                               .order_by(Article.created_at.desc())\
                               .all()
        
        articles_data = []
        for article in articles:
            # محاسبه زمان نسبی بر اساس زبان
            time_diff = datetime.utcnow() - article.created_at
            if lang == 'fa':
                if time_diff.days > 0:
                    time_ago = f"{time_diff.days} روز پیش"
                elif time_diff.seconds > 3600:
                    hours = time_diff.seconds // 3600
                    time_ago = f"{hours} ساعت پیش"
                else:
                    minutes = time_diff.seconds // 60
                    time_ago = f"{minutes} دقیقه پیش"
            elif lang == 'ku':
                if time_diff.days > 0:
                    time_ago = f"{time_diff.days} ڕۆژ لەمەوبەر"
                elif time_diff.seconds > 3600:
                    hours = time_diff.seconds // 3600
                    time_ago = f"{hours} کاتژمێر لەمەوبەر"
                else:
                    minutes = time_diff.seconds // 60
                    time_ago = f"{minutes} خولەک لەمەوبەر"
            else:  # en
                if time_diff.days > 0:
                    time_ago = f"{time_diff.days} days ago"
                elif time_diff.seconds > 3600:
                    hours = time_diff.seconds // 3600
                    time_ago = f"{hours} hours ago"
                else:
                    minutes = time_diff.seconds // 60
                    time_ago = f"{minutes} minutes ago"
            
            # فرمت کردن تعداد بازدید
            if article.views >= 1000:
                views_formatted = f"{article.views/1000:.1f}K"
            else:
                views_formatted = str(article.views)
            
            # ایجاد slug از عنوان انگلیسی
            english_title = article.title_en or article.title_fa
            slug = create_slug(english_title)
            
            articles_data.append({
                'id': article.id,
                'title': getattr(article, f'title_{lang}'),
                'excerpt': getattr(article, f'excerpt_{lang}') or 'خلاصه مقاله...',
                'slug': slug,
                'time_ago': time_ago,
                'views': views_formatted,
                'tags': getattr(article, f'tags_{lang}').split(',') if getattr(article, f'tags_{lang}') else []
            })
        
        return jsonify({
            'success': True,
            'articles': articles_data
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/debug/create-sample-articles')
def create_sample_articles():
    """ایجاد مقالات نمونه برای تست"""
    try:
        # بررسی وجود مقالات
        existing_count = Article.query.count()
        if existing_count > 0:
            return f'مقالات نمونه قبلاً ایجاد شده‌اند. تعداد موجود: {existing_count}'
        
        # مقالات نمونه
        sample_articles = [
            {
                'title_fa': '🎬 تکنیک‌های یادگیری زبان از طریق فیلم',
                'title_ku': '🎬 تەکنیکەکانی فێربوونی زمان لە ڕێگەی فیلم',
                'title_en': '🎬 Language Learning Techniques Through Movies',
                'excerpt_fa': 'یادگیری زبان انگلیسی از طریق تماشای فیلم یکی از بهترین روش‌های تقویت مهارت‌های زبانی است. در این مقاله تکنیک‌های موثر را بررسی می‌کنیم.',
                'excerpt_ku': 'فێربوونی زمانی ئینگلیزی لە ڕێگەی بینینی فیلم یەکێکە لە باشترین ڕێگەکانی بەهێزکردنەوەی لێهاتووییەکانی زمان.',
                'excerpt_en': 'Learning English through watching movies is one of the best methods for strengthening language skills.',
                'tags_fa': 'یادگیری,فیلم',
                'tags_ku': 'فێربوون,فیلم',
                'tags_en': 'learning,movie',
                'category': 'یادگیری',
                'reading_time': 8
            },
            {
                'title_fa': '📚 50 واژه پرکاربرد در آزمون‌های بین‌المللی',
                'title_ku': '📚 50 وشەی بەکارهێنراو لە تاقیکردنەوە نێودەوڵەتییەکان',
                'title_en': '📚 50 Essential Words for International Exams',
                'excerpt_fa': 'مجموعه‌ای از مهم‌ترین واژگان که در آزمون‌های بین‌المللی مانند IELTS و TOEFL بسیار پرتکرار هستند.',
                'excerpt_ku': 'کۆمەڵێک لە گرنگترین وشەکان کە لە تاقیکردنەوە نێودەوڵەتییەکان زۆر دووبارە دەبنەوە.',
                'excerpt_en': 'A collection of the most important words that are frequently repeated in international exams.',
                'tags_fa': 'واژگان,آزمون',
                'tags_ku': 'وشە,تاقیکردنەوە',
                'tags_en': 'vocabulary,exam',
                'category': 'واژگان',
                'reading_time': 12
            },
            {
                'title_fa': '⚙️ نکات مهم گرامر Present Perfect',
                'title_ku': '⚙️ گرنگترین خاڵەکانی گرامەری Present Perfect',
                'title_en': '⚙️ Important Points of Present Perfect Grammar',
                'excerpt_fa': 'در این مقاله به بررسی نکات مهم و کاربردی گرامر Present Perfect می‌پردازیم. این زمان یکی از پرکاربردترین زمان‌های انگلیسی است.',
                'excerpt_ku': 'لەم وتارەدا گرنگترین خاڵەکانی گرامەری Present Perfect بەکارهێنراو بەدوادا دەکەین.',
                'excerpt_en': 'In this article, we examine the important and practical points of Present Perfect grammar.',
                'tags_fa': 'گرامر,Present Perfect',
                'tags_ku': 'گرامەر,Present Perfect',
                'tags_en': 'grammar,present perfect',
                'category': 'گرامر',
                'reading_time': 10
            }
        ]
        
        # ایجاد مقالات
        for article_data in sample_articles:
            article = Article(**article_data)
            db.session.add(article)
        
        db.session.commit()
        
        return f'✅ {len(sample_articles)} مقاله نمونه با موفقیت ایجاد شد!'
        
    except Exception as e:
        db.session.rollback()
        return f'❌ خطا در ایجاد مقالات نمونه: {e}', 500

@app.route('/debug/update-articles-table')
def update_articles_table():
    """به‌روزرسانی جدول مقالات (حذف ستون‌های excerpt)"""
    try:
        from sqlalchemy import text
        
        # بررسی وجود ستون‌های excerpt
        result = db.session.execute(text("SHOW COLUMNS FROM articles LIKE 'excerpt_%'"))
        excerpt_columns = result.fetchall()
        
        if not excerpt_columns:
            return 'ستون‌های excerpt وجود ندارند. جدول قبلاً به‌روزرسانی شده است.'
        
        # حذف ستون‌های excerpt
        for column in excerpt_columns:
            column_name = column[0]
            db.session.execute(text(f"ALTER TABLE articles DROP COLUMN {column_name}"))
        
        db.session.commit()
        
        return f'✅ ستون‌های excerpt با موفقیت حذف شدند: {[col[0] for col in excerpt_columns]}'
        
    except Exception as e:
        db.session.rollback()
        return f'❌ خطا در به‌روزرسانی جدول: {e}', 500

@app.route('/debug/create-sample-articles-with-blocks')
def create_sample_articles_with_blocks():
    """ایجاد مقالات نمونه با بلاک‌ها برای تست"""
    try:
        # بررسی وجود مقالات
        existing_count = Article.query.count()
        if existing_count > 0:
            return f'مقالات نمونه قبلاً ایجاد شده‌اند. تعداد موجود: {existing_count}'
        
        # ایجاد مقاله اول: تکنیک‌های یادگیری
        article1 = Article(
            title_fa='🎬 تکنیک‌های یادگیری زبان از طریق فیلم',
            title_ku='🎬 تەکنیکەکانی فێربوونی زمان لە ڕێگەی فیلم',
            title_en='🎬 Language Learning Techniques Through Movies',
            excerpt_fa='یادگیری زبان انگلیسی از طریق تماشای فیلم یکی از بهترین روش‌های تقویت مهارت‌های زبانی است.',
            excerpt_ku='فێربوونی زمانی ئینگلیزی لە ڕێگەی بینینی فیلم یەکێکە لە باشترین ڕێگەکانی بەهێزکردنەوەی لێهاتووییەکانی زمان.',
            excerpt_en='Learning English through watching movies is one of the best methods for strengthening language skills.',
            tags_fa='یادگیری,فیلم',
            tags_ku='فێربوون,فیلم',
            tags_en='learning,movie',
            category='یادگیری',
            reading_time=8
        )
        db.session.add(article1)
        db.session.flush()  # برای دریافت ID
        
        # بلاک‌های مقاله اول
        blocks1 = [
            ArticleBlock(article_id=article1.id, block_type='subtitle', content_fa='چرا فیلم؟', order_num=1),
            ArticleBlock(article_id=article1.id, block_type='paragraph', content_fa='فیلم‌ها منابع عالی برای یادگیری زبان هستند زیرا زبان طبیعی و روزمره را نشان می‌دهند.', order_num=2),
            ArticleBlock(article_id=article1.id, block_type='list', content_fa='زبان طبیعی و روزمره را نشان می‌دهند\nلهجه‌های مختلف را ارائه می‌دهند\nفرهنگ و آداب و رسوم را آموزش می‌دهند', order_num=3),
            ArticleBlock(article_id=article1.id, block_type='subtitle', content_fa='تکنیک‌های موثر', order_num=4),
            ArticleBlock(article_id=article1.id, block_type='note', content_fa='برای یادگیری بهتر از فیلم‌ها ابتدا با زیرنویس فارسی تماشا کنید، سپس با زیرنویس انگلیسی و در نهایت بدون زیرنویس.', order_num=5),
        ]
        
        for block in blocks1:
            db.session.add(block)
        
        # ایجاد مقاله دوم: واژگان
        article2 = Article(
            title_fa='📚 50 واژه پرکاربرد در آزمون‌های بین‌المللی',
            title_ku='📚 50 وشەی بەکارهێنراو لە تاقیکردنەوە نێودەوڵەتییەکان',
            title_en='📚 50 Essential Words for International Exams',
            excerpt_fa='مجموعه‌ای از مهم‌ترین واژگان که در آزمون‌های بین‌المللی مانند IELTS و TOEFL بسیار پرتکرار هستند.',
            excerpt_ku='کۆمەڵێک لە گرنگترین وشەکان کە لە تاقیکردنەوە نێودەوڵەتییەکان زۆر دووبارە دەبنەوە.',
            excerpt_en='A collection of the most important words that are frequently repeated in international exams.',
            tags_fa='واژگان,آزمون',
            tags_ku='وشە,تاقیکردنەوە',
            tags_en='vocabulary,exam',
            category='واژگان',
            reading_time=12
        )
        db.session.add(article2)
        db.session.flush()
        
        # بلاک‌های مقاله دوم
        blocks2 = [
            ArticleBlock(article_id=article2.id, block_type='subtitle', content_fa='واژگان پرکاربرد', order_num=1),
            ArticleBlock(article_id=article2.id, block_type='vocabulary', content_fa='Accomplish - انجام دادن، به پایان رساندن', order_num=2),
            ArticleBlock(article_id=article2.id, block_type='vocabulary', content_fa='Beneficial - سودمند، مفید', order_num=3),
            ArticleBlock(article_id=article2.id, block_type='vocabulary', content_fa='Comprehensive - جامع، کامل', order_num=4),
            ArticleBlock(article_id=article2.id, block_type='note', content_fa='هر روز 5-10 واژه جدید یاد بگیرید و در جملات مختلف استفاده کنید.', order_num=5),
        ]
        
        for block in blocks2:
            db.session.add(block)
        
        # ایجاد مقاله سوم: گرامر
        article3 = Article(
            title_fa='⚙️ نکات مهم گرامر Present Perfect',
            title_ku='⚙️ گرنگترین خاڵەکانی گرامەری Present Perfect',
            title_en='⚙️ Important Points of Present Perfect Grammar',
            excerpt_fa='در این مقاله به بررسی نکات مهم و کاربردی گرامر Present Perfect می‌پردازیم.',
            excerpt_ku='لەم وتارەدا گرنگترین خاڵەکانی گرامەری Present Perfect بەکارهێنراو بەدوادا دەکەین.',
            excerpt_en='In this article, we examine the important and practical points of Present Perfect grammar.',
            tags_fa='گرامر,Present Perfect',
            tags_ku='گرامەر,Present Perfect',
            tags_en='grammar,present perfect',
            category='گرامر',
            reading_time=10
        )
        db.session.add(article3)
        db.session.flush()
        
        # بلاک‌های مقاله سوم
        blocks3 = [
            ArticleBlock(article_id=article3.id, block_type='subtitle', content_fa='کاربردهای Present Perfect', order_num=1),
            ArticleBlock(article_id=article3.id, block_type='paragraph', content_fa='Present Perfect در موارد زیر استفاده می‌شود:', order_num=2),
            ArticleBlock(article_id=article3.id, block_type='list', content_fa='عملی که در گذشته شروع شده و تا حال ادامه دارد\nتجربیات زندگی\nعملی که در گذشته انجام شده اما نتیجه آن در حال حاضر مهم است', order_num=3),
            ArticleBlock(article_id=article3.id, block_type='subtitle', content_fa='ساختار', order_num=4),
            ArticleBlock(article_id=article3.id, block_type='code', content_fa='Subject + have/has + Past Participle', order_num=5),
            ArticleBlock(article_id=article3.id, block_type='subtitle', content_fa='مثال‌ها', order_num=6),
            ArticleBlock(article_id=article3.id, block_type='example', content_fa='I have lived in Tehran for 5 years. - من 5 سال است که در تهران زندگی می‌کنم.', order_num=7),
            ArticleBlock(article_id=article3.id, block_type='example', content_fa='She has never been to Paris. - او هرگز به پاریس نرفته است.', order_num=8),
            ArticleBlock(article_id=article3.id, block_type='subtitle', content_fa='تمرین', order_num=9),
            ArticleBlock(article_id=article3.id, block_type='exercise', content_fa='جملات زیر را با استفاده از Present Perfect کامل کنید:\n1. I _____ (live) in this city for 10 years.\n2. She _____ (never/visit) Paris before.', order_num=10),
        ]
        
        for block in blocks3:
            db.session.add(block)
        
        db.session.commit()
        
        return f'✅ 3 مقاله نمونه با بلاک‌ها با موفقیت ایجاد شد!'
        
    except Exception as e:
        db.session.rollback()
        return f'❌ خطا در ایجاد مقالات نمونه: {e}', 500

@app.route('/debug/recreate-articles-tables')
def recreate_articles_tables():
    """حذف و ایجاد مجدد جدول‌های مقالات"""
    try:
        # حذف جدول‌ها
        ArticleBlock.__table__.drop(db.engine, checkfirst=True)
        Article.__table__.drop(db.engine, checkfirst=True)
        
        # ایجاد مجدد
        Article.__table__.create(db.engine, checkfirst=True)
        ArticleBlock.__table__.create(db.engine, checkfirst=True)
        
        return '✅ جدول‌های مقالات با موفقیت حذف و ایجاد مجدد شد!'
    except Exception as e:
        return f'❌ خطا در ایجاد مجدد جدول‌ها: {e}', 500

def create_slug(text):
    """ایجاد slug از متن انگلیسی"""
    if not text:
        return ''
    
    # تبدیل به حروف کوچک
    text = text.lower()
    
    # حذف کاراکترهای خاص و جایگزینی با خط تیره
    text = re.sub(r'[^\w\s-]', '', text)
    
    # جایگزینی فاصله‌ها با خط تیره
    text = re.sub(r'[-\s]+', '-', text)
    
    # حذف خط تیره از ابتدا و انتها
    text = text.strip('-')
    
    return text

# --- مدیریت مقالات ---
@app.route('/admin/articles')
@admin_required
def admin_articles():
    try:
        articles = Article.query.order_by(Article.created_at.desc()).all()
        return render_template('admin/articles.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             articles=articles)
    except Exception as e:
        print(f"Error in admin_articles: {e}")
        return render_template('admin/articles.html', 
                             admin_username=session.get('admin_username', 'مدیر'),
                             articles=[])

@app.route('/admin/articles/new', methods=['GET', 'POST'])
@admin_required
def admin_new_article():
    if request.method == 'POST':
        try:
            data = request.form
            
            # ایجاد مقاله جدید
            article = Article(
                title_fa=data.get('title_fa', ''),
                title_ku=data.get('title_ku', ''),
                title_en=data.get('title_en', ''),
                excerpt_fa=data.get('excerpt_fa', ''),
                excerpt_ku=data.get('excerpt_ku', ''),
                excerpt_en=data.get('excerpt_en', ''),
                tags_fa=data.get('tags_fa', ''),
                tags_ku=data.get('tags_ku', ''),
                tags_en=data.get('tags_en', ''),
                category=data.get('category', 'گرامر'),
                reading_time=int(data.get('reading_time', 10)),
                is_published=data.get('is_published') == 'on'
            )
            
            db.session.add(article)
            db.session.commit()
            
            # ایجاد بلاک‌های محتوا
            block_types = request.form.getlist('block_type[]')
            contents_fa = request.form.getlist('content_fa[]')
            contents_ku = request.form.getlist('content_ku[]')
            contents_en = request.form.getlist('content_en[]')
            order_nums = request.form.getlist('order_num[]')
            block_metadatas = request.form.getlist('block_metadata[]')
            
            for i in range(len(block_types)):
                if block_types[i] and contents_fa[i]:
                    try:
                        metadata = json.loads(block_metadatas[i]) if block_metadatas[i] else None
                    except:
                        metadata = None
                    
                    block = ArticleBlock(
                        article_id=article.id,
                        block_type=block_types[i],
                        content_fa=contents_fa[i],
                        content_ku=contents_ku[i] if contents_ku[i] else '',
                        content_en=contents_en[i] if contents_en[i] else '',
                        order_num=int(order_nums[i]) if order_nums[i] else i+1,
                        block_metadata=metadata
                    )
                    db.session.add(block)
            
            db.session.commit()
            
            return redirect(url_for('admin_articles'))
            
        except Exception as e:
            db.session.rollback()
            print(f"Error creating article: {e}")
            return render_template('admin/article_form_new.html', 
                                 admin_username=session.get('admin_username', 'مدیر'),
                                 error=str(e))
    
    return render_template('admin/article_form_new.html', 
                         admin_username=session.get('admin_username', 'مدیر'),
                         article=None)

@app.route('/admin/articles/<int:article_id>/edit', methods=['GET', 'POST'])
@admin_required
def admin_edit_article(article_id):
    article = Article.query.get_or_404(article_id)
    
    if request.method == 'POST':
        try:
            data = request.form
            
            # Debug: نمایش داده‌های دریافتی
            print(f"Received form data: {dict(data)}")
            print(f"Article ID: {article.id}")
            
            # به‌روزرسانی مقاله
            article.title_fa = data.get('title_fa', '')
            article.title_ku = data.get('title_ku', '')
            article.title_en = data.get('title_en', '')
            article.excerpt_fa = data.get('excerpt_fa', '')
            article.excerpt_ku = data.get('excerpt_ku', '')
            article.excerpt_en = data.get('excerpt_en', '')
            article.tags_fa = data.get('tags_fa', '')
            article.tags_ku = data.get('tags_ku', '')
            article.tags_en = data.get('tags_en', '')
            article.category = data.get('category', 'گرامر')
            article.reading_time = int(data.get('reading_time', 10))
            article.is_published = data.get('is_published') == 'on'
            
            # به‌روزرسانی مقاله اصلی
            db.session.commit()
            
            # حذف بلاک‌های قدیمی
            ArticleBlock.query.filter_by(article_id=article.id).delete()
            
            # ایجاد بلاک‌های جدید
            block_types = request.form.getlist('block_type[]')
            contents_fa = request.form.getlist('content_fa[]')
            contents_ku = request.form.getlist('content_ku[]')
            contents_en = request.form.getlist('content_en[]')
            order_nums = request.form.getlist('order_num[]')
            block_metadatas = request.form.getlist('block_metadata[]')
            
            print(f"Block types: {block_types}")
            print(f"Contents FA: {contents_fa}")
            
            for i in range(len(block_types)):
                # بررسی اینکه بلاک محتوا دارد
                if contents_fa[i] and contents_fa[i].strip():
                    # اگر نوع بلاک انتخاب نشده، از کپسل بالای بلاک استفاده کن
                    block_type = block_types[i]
                    if not block_type or block_type == '':
                        # اینجا باید از کپسل بالای بلاک استفاده کنیم
                        # فعلاً از paragraph به عنوان پیش‌فرض استفاده می‌کنیم
                        block_type = 'paragraph'
                        print(f"Block {i}: Using default type 'paragraph'")
                    
                    try:
                        metadata = json.loads(block_metadatas[i]) if block_metadatas[i] else None
                    except:
                        metadata = None
                    
                    block = ArticleBlock(
                        article_id=article.id,
                        block_type=block_type,
                        content_fa=contents_fa[i],
                        content_ku=contents_ku[i] if contents_ku[i] else '',
                        content_en=contents_en[i] if contents_en[i] else '',
                        order_num=int(order_nums[i]) if order_nums[i] else i+1,
                        block_metadata=metadata
                    )
                    db.session.add(block)
                    print(f"Added block {i}: type={block_type}, content={contents_fa[i][:50]}...")
            
            db.session.commit()
            return redirect(url_for('admin_articles'))
            
        except Exception as e:
            db.session.rollback()
            print(f"Error updating article: {e}")
            return render_template('admin/article_form_new.html', 
                                 admin_username=session.get('admin_username', 'مدیر'),
                                 article=article,
                                 error=str(e))
    
    return render_template('admin/article_form_new.html', 
                         admin_username=session.get('admin_username', 'مدیر'),
                         article=article)

@app.route('/admin/articles/<int:article_id>/delete', methods=['POST'])
@admin_required
def admin_delete_article(article_id):
    try:
        article = Article.query.get_or_404(article_id)
        
        # حذف بلاک‌ها
        ArticleBlock.query.filter_by(article_id=article.id).delete()
        
        # حذف مقاله
        db.session.delete(article)
        db.session.commit()
        
        return jsonify({"success": True, "message": "مقاله با موفقیت حذف شد"})
        
    except Exception as e:
        db.session.rollback()
        print(f"Error deleting article: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/admin/article-blocks/<int:article_id>')
@admin_required
def get_article_blocks(article_id):
    try:
        blocks = ArticleBlock.query.filter_by(article_id=article_id).order_by(ArticleBlock.order_num).all()
        
        blocks_data = []
        for block in blocks:
            blocks_data.append({
                'id': block.id,
                'block_type': block.block_type,
                'content_fa': block.content_fa,
                'content_ku': block.content_ku,
                'content_en': block.content_en,
                'order_num': block.order_num,
                'block_metadata': block.block_metadata
            })
        
        return jsonify({"success": True, "blocks": blocks_data})
        
    except Exception as e:
        print(f"Error getting article blocks: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route('/api/admin/save-block', methods=['POST'])
@admin_required
def save_block():
    try:
        data = request.get_json()
        
        # بررسی وجود article_id
        if not data.get('article_id'):
            return jsonify({"success": False, "message": "شناسه مقاله الزامی است"}), 400
        
        article_id = data['article_id']
        article = Article.query.get(article_id)
        
        if not article:
            return jsonify({"success": False, "message": "مقاله یافت نشد"}), 404
        
        # بررسی وجود بلاک بر اساس ID (اگر موجود باشد)
        block = None
        if data.get('block_id'):
            block = ArticleBlock.query.get(data['block_id'])
        
        # اگر block_id نبود، بر اساس block_type و order_num جستجو کن
        if not block:
            block = ArticleBlock.query.filter_by(
                article_id=article_id,
                block_type=data['block_type'],
                order_num=data['order_num']
            ).first()
        
        if block:
            # به‌روزرسانی بلاک موجود
            block.content_fa = data['content_fa']
            block.content_ku = data['content_ku']
            block.content_en = data['content_en']
            block.block_metadata = {
                'direction': data.get('direction'),
                'position': data.get('position')
            }
        else:
            # ایجاد بلاک جدید
            block = ArticleBlock(
                article_id=article_id,
                block_type=data['block_type'],
                content_fa=data['content_fa'],
                content_ku=data['content_ku'],
                content_en=data['content_en'],
                order_num=data['order_num'],
                block_metadata={
                    'direction': data.get('direction'),
                    'position': data.get('position')
                }
            )
            db.session.add(block)
        
        db.session.commit()
        
        return jsonify({
            "success": True, 
            "message": "بلاک با موفقیت ذخیره شد",
            "block_id": block.id
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"Error saving block: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)