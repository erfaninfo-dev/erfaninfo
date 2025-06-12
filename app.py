# app.py

import os
import json
import random
import re 
from flask import Flask, render_template, request, jsonify
from supabase import create_client, Client
from collections import defaultdict

app = Flask(__name__)

# --- بخش اتصال به Supabase ---
# توصیه: در محیط پروداکشن، این مقادیر را از متغیرهای محیطی (Environment Variables) بخوانید
SUPABASE_URL = "https://yarewbyqmrsnrnwjrrkr.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlhcmV3YnlxbXJzbnJud2pycmtyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwMzE0NzQsImV4cCI6MjA2NDYwNzQ3NH0.wtOlRWHkwPFW5SVE0V6fp8wlhNEfTCvnFZLhlF1zSBU"
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)



@app.route('/')
def home():
    return render_template('home_new.html')


@app.route('/tests')
def grammar_tests():
    """
    صفحه انتخاب آزمون را به صورت گروه بندی شده نمایش می دهد.
    مباحث (content) از دیتابیس واکشی و به صورت کاملا پویا گروه بندی می شوند.
    """
    try:
        # === تغییر: description و image_url از کوئری select حذف شدند ===
        response = supabase.table('questions').select("content, order_num").order("order_num").execute()
        
        all_contents_raw = []
        content_order_map = {} 
        content_details_map = {} # این دیکشنری خالی می ماند یا حذف می شود، اما برای سازگاری موقت باقی می ماند

        for item in response.data:
            if item['content']:
                content_name = item['content'].strip().title()
                all_contents_raw.append(content_name)
                if item.get('order_num') is not None:
                    content_order_map[content_name] = item['order_num']
                
                # نیازی به ذخیره description و image_url نیست
        
        unique_contents = sorted(list(set(all_contents_raw)))

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
        
        sorted_main_categories = sorted(list(main_categories_found), 
                                        key=lambda x: content_order_map.get(x, float('inf')))


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

        # content_details دیگر استفاده نمی شود، اما برای سازگاری ارسال می شود
        return render_template('tests.html', 
                               grouped_tenses=final_grouped_tenses,
                               content_details={}) # دیکشنری خالی ارسال می کنیم
    except Exception as e:
        print(f"Error in grammar_tests: {e}")
        return f"Error connecting to database: {e}", 500


@app.route('/test/<content_name>')
def run_test(content_name):
    try:
        if '(' not in content_name:
            response = supabase.table('questions').select("*").like("content", f"{content_name}%").execute()
        else:
            response = supabase.table('questions').select("*").eq("content", content_name).execute()

        if not response.data:
            return "Quiz not found!", 404

        all_questions = response.data
        if len(all_questions) > 20:
            selected_questions = random.sample(all_questions, 20)
        else:
            selected_questions = all_questions

        formatted_questions = []
        for q in selected_questions:
            options = [
                opt for opt in [
                    q.get('option1'), q.get('option2'), q.get('option3'), q.get('option4')
                ] if opt is not None
            ]
            formatted_q = {
                "id": q.get('id'), "text": q.get('question_text'),
                "options": options, "answer": q.get('correct_answer')
            }
            formatted_questions.append(formatted_q)

        return render_template('quiz.html',
                               title=content_name,
                               initial_quiz_questions_json=json.dumps(formatted_questions))

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
        response = supabase.table('student_quiz').select("*").eq("code", code).execute()

        if response.data:
            all_personalized_questions = response.data
            
            if len(all_personalized_questions) > 20:
                selected_personalized_questions = random.sample(all_personalized_questions, 20)
            else:
                selected_personalized_questions = all_personalized_questions
            
            quiz_title = "آزمون شخصی شما"
            if selected_personalized_questions and selected_personalized_questions[0].get('content'):
                quiz_title = selected_personalized_questions[0]['content']

            formatted_questions = []
            for q in selected_personalized_questions:
                options = [
                    opt for opt in [
                        q.get('option1'), q.get('option2'), q.get('option3'), q.get('option4')
                    ] if opt is not None
                ]
                formatted_q = {
                    "id": q.get('id'), "text": q.get('question_text'),
                    "options": options, "answer": q.get('correct_answer')
                }
                formatted_questions.append(formatted_q)

            return jsonify({
                "success": True,
                "title": quiz_title,
                "questions": formatted_questions
            })
        else:
            return jsonify({"success": False, "message": "کد تمرین نامعتبر است یا تمرینی با این کد یافت نشد."}), 404
    except Exception as e:
        print(f"Error fetching personalized quiz: {e}")
        return jsonify({"success": False, "message": "خطا در واکشی اطلاعات آزمون شخصی. لطفا مجددا تلاش کنید."}), 500


@app.route('/run-personalized-quiz-from-js')
def run_personalized_quiz_page():
    return render_template('quiz.html', title="در حال بارگذاری آزمون شخصی...")


@app.route('/api/save-result', methods=['POST'])
def save_result():
    data = request.get_json()
    try:
        supabase.table('results').insert({
            'user_name': data.get('userName'),
            'quiz_name': data.get('quizName'),
            'score': data.get('score'),
            'total_questions': data.get('totalQuestions')
        }).execute()
        return jsonify({"success": True, "message": "Result saved successfully!"})
    except Exception as e:
        print(f"Error saving result: {e}")
        return jsonify({"success": False, "message": str(e)}), 500


@app.route('/youtube')
def youtube_videos():
    return render_template('youtube.html')


@app.route('/page/<int:page_number>')
def show_page(page_number):
    return render_template('page_detail.html', number=page_number)


if __name__ == '__main__':
    app.run(debug=True)