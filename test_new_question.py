#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
تست گزارش سوال جدید با دلایل فارسی
"""

import requests
import json
import time

def test_new_question_report():
    """تست گزارش سوال جدید"""
    
    # استفاده از timestamp برای ایجاد ID منحصر به فرد
    unique_id = int(time.time())
    
    url = "http://localhost:5000/api/report-question"
    
    # دلایل فارسی
    reasons = [
        'سوال اشتباهه!',
        'پاسخ درست اشتباهه!',
        'بیش از یک جواب درست!',
        'سایر'
    ]
    
    print("تست گزارش سوال جدید با دلایل فارسی:")
    print("=" * 50)
    
    for i, reason in enumerate(reasons):
        test_data = {
            'question_id': unique_id + i,  # ID منحصر به فرد
            'question_text': f'سوال تست {i+1} برای بررسی دلیل: {reason}',
            'options': ['گزینه 1', 'گزینه 2', 'گزینه 3', 'گزینه 4'],
            'correct_answer': 'گزینه 1',
            'quiz_name': 'تست دلایل فارسی',
            'content': 'تست',
            'quiz_type': 'general',
            'reported_reason': reason
        }
        
        try:
            response = requests.post(url, json=test_data)
            result = response.json()
            
            if result.get('success'):
                print(f"✅ {reason}: موفق")
            else:
                print(f"❌ {reason}: {result.get('message')}")
                
        except Exception as e:
            print(f"❌ {reason}: خطا در اتصال - {e}")

if __name__ == "__main__":
    test_new_question_report() 