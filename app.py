# app.py

import os
import json
import random
import re 
from flask import Flask, render_template, request, jsonify, url_for, make_response, session, redirect
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
from datetime import datetime, timedelta
from sqlalchemy import inspect
from sqlalchemy import func
from urllib.parse import unquote
import random
import hashlib
import os
sys_random = random.SystemRandom()
import jdatetime

load_dotenv()  # بارگذاری متغیرهای محیطی از .env

app = Flask(__name__)

# تنظیمات اتصال به MySQL
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+mysqlconnector://{os.getenv('MYSQL_USER')}:{os.getenv('MYSQL_PASSWORD')}"
    f"@{os.getenv('MYSQL_HOST')}/{os.getenv('MYSQL_DB')}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
    'pool_pre_ping': True
}

# تنظیمات session برای admin
app.secret_key = os.getenv('SECRET_KEY', 'your-secret-key-change-this-in-production')

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
    # سایر ستون‌ها در صورت نیاز اضافه شود

class Result(db.Model):
    __tablename__ = 'results'
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(255))
    quiz_name = db.Column(db.String(255))
    score = db.Column(db.Integer)
    total_questions = db.Column(db.Integer)
    created_at = db.Column(db.DateTime)

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


@app.route('/tests')
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
        return render_template('tests.html', grouped_tenses=final_grouped_tenses, content_details={})
    except Exception as e:
        print(f"Error in grammar_tests: {e}")
        return f"Error connecting to database: {e}", 500


@app.route('/test/<path:content_name>')
def run_test(content_name):
    try:
        decoded_content = unquote(content_name).strip().lower()
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
                "options": options, "answer": correct_answer_text
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
            return jsonify({"success": False, "message": "سوالی یافت نشد."}), 404

        # گروه‌بندی بر اساس unit
        from collections import defaultdict
        unit_map = defaultdict(list)
        for q in all_personalized_questions:
            unit_map[q.unit].append(q)
        # ترتیب یونیت‌ها از کم به زیاد
        sorted_units = sorted(unit_map.keys(), key=lambda x: float(x))
        final_questions = []
        for unit in sorted_units:
            questions_in_unit = unit_map[unit]
            questions_in_unit_list = StudentQuiz.query.filter_by(code=code, unit=unit).order_by(func.random()).limit(15).all()
            selected = list(questions_in_unit_list)
            final_questions.extend(selected)
        # فرمت خروجی
        formatted_questions = []
        print([getattr(q, 'content', None) for q in final_questions])  # DEBUG: نمایش مقادیر content
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
                "code": q.code  # اضافه کردن کد سوال
            }
            formatted_questions.append(formatted_q)
        print('DEBUG: formatted_questions =', formatted_questions)  # DEBUG: نمایش خروجی نهایی سوالات
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
        print(f"Error in get_personalized_quiz: {e}")
        return jsonify({"success": False, "message": f"خطا: {e}"}), 500


@app.route('/run-personalized-quiz-from-js')
def run_personalized_quiz_page():
    return render_template('quiz.html', title="در حال بارگذاری آزمون شخصی...")


@app.route('/api/save-result', methods=['POST'])
def save_result():
    data = request.get_json()
    user_name = data.get('user_name')
    quiz_name = data.get('quiz_name')
    score = data.get('score')
    total_questions = data.get('total_questions')
    try:
        new_result = Result(user_name=user_name, quiz_name=quiz_name, score=score, total_questions=total_questions, created_at=datetime.now())
        db.session.add(new_result)
        db.session.commit()
        return jsonify({"success": True})
    except Exception as e:
        print(f"Error in save_result: {e}")
        return jsonify({"success": False, "message": str(e)}), 500


@app.route('/youtube')
def youtube_videos():
    return render_template('youtube.html')


@app.route('/page/<int:page_number>')
def show_page(page_number):
    return render_template('page_detail.html', number=page_number)


@app.route('/api/report-question', methods=['POST'])
def report_question():
    try:
        data = request.get_json()
        
        # اضافه کردن debug log کامل
        print("=" * 50)
        print("DEBUG: گزارش جدید دریافت شد")
        print(f"DEBUG: تمام داده‌های دریافتی: {data}")
        print(f"DEBUG: reported_reason = '{data.get('reported_reason')}'")
        print(f"DEBUG: نوع reported_reason = {type(data.get('reported_reason'))}")
        print("=" * 50)
        
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
            return jsonify({"success": False, "message": "این سوال قبلاً گزارش شده است"}), 400
        
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
            user_name=data.get('user_name', '')  # نام کاربر
        )
        
        db.session.add(wrong_question)
        db.session.commit()
        
        return jsonify({
            "success": True, 
            "message": "سوال گزارش شد ✅"
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"Error in report_question: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"success": False, "message": f"خطا در ثبت گزارش: {str(e)}"}), 500

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

@app.route('/admin/wrong-questions')
@admin_required
def admin_wrong_questions_page():
    return render_template('admin/wrong_questions.html')

@app.route('/admin/reports/<status>')
@admin_required
def admin_reports_by_status(status):
    return render_template('admin/wrong_questions.html', default_status=status)

@app.route('/api/admin/wrong-questions')
@admin_required
def get_wrong_questions():
    try:
        # دریافت فیلترها
        status_filter = request.args.get('status', 'pending')
        quiz_type_filter = request.args.get('quiz_type', 'all')
        
        # ساخت کوئری
        query = WrongQuestion.query
        
        if status_filter != 'all':
            query = query.filter_by(status=status_filter)
        
        if quiz_type_filter != 'all':
            query = query.filter_by(question_type=quiz_type_filter)
        
        # مرتب‌سازی بر اساس تاریخ (جدیدترین اول)
        wrong_questions = query.order_by(WrongQuestion.created_at.desc()).all()
        
        # تبدیل به JSON
        reports = []
        for wq in wrong_questions:
            reports.append({
                'id': wq.id,
                'question_id': wq.question_id,
                'question_text': wq.question_text,
                'options': wq.options,
                'correct_answer': wq.correct_answer,
                'user_ip': wq.user_ip,
                'quiz_name': wq.quiz_name,
                'content': wq.content,
                'question_type': wq.question_type,
                'reported_reason': wq.reported_reason,
                'created_at': wq.created_at.isoformat() if wq.created_at else None,
                'status': wq.status,
                'user_name': wq.user_name  # اضافه کردن نام کاربر
            })
        
        # محاسبه آمار
        total_reports = WrongQuestion.query.count()
        pending_reports = WrongQuestion.query.filter_by(status='pending').count()
        today_reports = WrongQuestion.query.filter(
            WrongQuestion.created_at >= datetime.utcnow().date()
        ).count()
        
        stats = {
            'total': total_reports,
            'pending': pending_reports,
            'today': today_reports
        }
        
        return jsonify({
            "success": True,
            "reports": reports,
            "stats": stats
        })
        
    except Exception as e:
        print(f"Error in get_wrong_questions: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

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
            formatted_results.append({
                'id': result.id,
                'user_name': result.user_name or 'کاربر ناشناس',
                'quiz_name': result.quiz_name or 'آزمون ناشناس',
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

@app.route('/test-ui')
def test_ui():
    """صفحه تست رابط کاربری"""
    return render_template('test_ui.html')


if __name__ == '__main__':
    app.run(debug=True)