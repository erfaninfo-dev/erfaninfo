#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
تست ارسال دلایل فارسی برای گزارش سوالات
"""

import requests
import json

def test_persian_reasons():
    """تست ارسال دلایل فارسی"""
    
    # URL تست
    url = "http://localhost:5000/api/report-question"
    
    # داده‌های تست
    test_data = {
        'question_id': 999,
        'question_text': 'سوال تست برای بررسی دلایل فارسی',
        'options': ['گزینه 1', 'گزینه 2', 'گزینه 3', 'گزینه 4'],
        'correct_answer': 'گزینه 1',
        'quiz_name': 'تست دلایل فارسی',
        'content': 'تست',
        'quiz_type': 'general',
        'reported_reason': 'سوال اشتباهه!'  # دلیل فارسی
    }
    
    try:
        # ارسال درخواست
        response = requests.post(url, json=test_data)
        
        print("=" * 50)
        print("تست ارسال دلیل فارسی")
        print("=" * 50)
        print(f"دلیل ارسالی: {test_data['reported_reason']}")
        print(f"کد پاسخ: {response.status_code}")
        print(f"پاسخ سرور: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                print("✅ تست موفق بود!")
            else:
                print(f"❌ خطا: {result.get('message')}")
        else:
            print(f"❌ خطای HTTP: {response.status_code}")
            
    except Exception as e:
        print(f"❌ خطا در اتصال: {e}")

def test_all_reasons():
    """تست تمام دلایل فارسی"""
    
    reasons = [
        'سوال اشتباهه!',
        'پاسخ درست اشتباهه!',
        'بیش از یک جواب درست!',
        'سایر'
    ]
    
    url = "http://localhost:5000/api/report-question"
    
    for i, reason in enumerate(reasons, 1):
        test_data = {
            'question_id': 999 + i,
            'question_text': f'سوال تست {i}',
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
    print("شروع تست دلایل فارسی...")
    test_persian_reasons()
    print("\n" + "=" * 50)
    print("تست تمام دلایل:")
    test_all_reasons() 