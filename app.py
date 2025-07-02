# app.py

import os
import json
import random
import re 
from flask import Flask, render_template, request, jsonify, url_for
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
from datetime import datetime
from sqlalchemy import inspect

load_dotenv()  # بارگذاری متغیرهای محیطی از .env

app = Flask(__name__)

# تنظیمات اتصال به MySQL
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+mysqlconnector://{os.getenv('MYSQL_USER')}:{os.getenv('MYSQL_PASSWORD')}"
    f"@{os.getenv('MYSQL_HOST')}/{os.getenv('MYSQL_DB')}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
print(f"DEBUG: DATABASE_URL being used: {app.config['SQLALCHEMY_DATABASE_URI']}")

db = SQLAlchemy(app)

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
    user_id = db.Column(db.String(255))
    quiz_code = db.Column(db.String(255))
    score = db.Column(db.Integer)
    created_at = db.Column(db.DateTime)
    # سایر ستون‌ها در صورت نیاز اضافه شود

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


@app.route('/test/<content_name>')
def run_test(content_name):
    try:
        if '(' not in content_name:
            all_questions = Question.query.filter(Question.content.like(f"{content_name}%")).all()
        else:
            all_questions = Question.query.filter_by(content=content_name).all()
        if not all_questions:
            return "Quiz not found!", 404
        if len(all_questions) > 20:
            selected_questions = random.sample(all_questions, 20)
        else:
            selected_questions = all_questions
        formatted_questions = []
        for q in selected_questions:
            options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt is not None]
            formatted_q = {
                "id": q.id, "text": q.question_text,
                "options": options, "answer": q.correct_answer
            }
            formatted_questions.append(formatted_q)
        return render_template('quiz.html', title=content_name, initial_quiz_questions_json=json.dumps(formatted_questions))
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
        import random
        unit_map = defaultdict(list)
        for q in all_personalized_questions:
            unit_map[q.unit].append(q)
        # ترتیب یونیت‌ها از کم به زیاد
        sorted_units = sorted(unit_map.keys(), key=lambda x: float(x))
        final_questions = []
        for unit in sorted_units:
            questions_in_unit = unit_map[unit]
            if len(questions_in_unit) > 15:
                selected = random.sample(questions_in_unit, 15)
            else:
                selected = questions_in_unit
            # ترتیب سوالات هر یونیت تصادفی اما یونیت‌ها به ترتیب
            random.shuffle(selected)
            final_questions.extend(selected)
        # فرمت خروجی
        formatted_questions = []
        print([getattr(q, 'content', None) for q in final_questions])  # DEBUG: نمایش مقادیر content
        for q in final_questions:
            options = [opt for opt in [q.option1, q.option2, q.option3, q.option4] if opt is not None]
            formatted_q = {
                "id": q.id, "text": q.question_text,
                "options": options, "answer": q.correct_answer,
                "content": getattr(q, "content", None)
            }
            formatted_questions.append(formatted_q)
        # تعیین عنوان آزمون بر اساس content
        if final_questions:
            unique_contents = list({q.content for q in final_questions if q.content})
            if len(unique_contents) == 1:
                quiz_title = unique_contents[0]
            else:
                quiz_title = '، '.join(unique_contents)
        else:
            quiz_title = "آزمون شخصی"
        return jsonify({"success": True, "questions": formatted_questions, "title": quiz_title})
    except Exception as e:
        print(f"Error in get_personalized_quiz: {e}")
        return jsonify({"success": False, "message": f"خطا: {e}"}), 500


@app.route('/run-personalized-quiz-from-js')
def run_personalized_quiz_page():
    return render_template('quiz.html', title="در حال بارگذاری آزمون شخصی...")


@app.route('/api/save-result', methods=['POST'])
def save_result():
    data = request.get_json()
    user_id = data.get('user_id')
    quiz_code = data.get('quiz_code')
    score = data.get('score')
    try:
        new_result = Result(user_id=user_id, quiz_code=quiz_code, score=score, created_at=datetime.now())
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


@app.route('/debug/columns')
def debug_columns():
    inspector = inspect(db.engine)
    columns = inspector.get_columns('questions')
    col_names = [column['name'] for column in columns]
    return '<br>'.join(col_names)


if __name__ == '__main__':
    app.run(debug=True)