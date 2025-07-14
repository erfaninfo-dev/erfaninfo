#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
اسکریپت اجرای migration برای تغییر ستون reported_reason
"""

import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

def run_migration():
    """اجرای migration"""
    
    # اتصال به دیتابیس
    connection = mysql.connector.connect(
        host=os.getenv('MYSQL_HOST'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        database=os.getenv('MYSQL_DB')
    )
    
    cursor = connection.cursor()
    
    try:
        print("شروع migration...")
        
        # بررسی ساختار فعلی جدول
        cursor.execute("DESCRIBE wrong_questions")
        columns = cursor.fetchall()
        print("ساختار فعلی جدول:")
        for column in columns:
            print(f"  {column[0]}: {column[1]}")
        
        # اضافه کردن ستون جدید
        print("\nاضافه کردن ستون جدید...")
        cursor.execute("""
            ALTER TABLE wrong_questions 
            ADD COLUMN reported_reason_new VARCHAR(255) DEFAULT 'سایر'
        """)
        
        # به‌روزرسانی مقادیر موجود
        print("به‌روزرسانی مقادیر موجود...")
        cursor.execute("""
            UPDATE wrong_questions 
            SET reported_reason_new = 'سوال اشتباهه!' 
            WHERE reported_reason = 'wrong_question'
        """)
        
        cursor.execute("""
            UPDATE wrong_questions 
            SET reported_reason_new = 'پاسخ درست اشتباهه!' 
            WHERE reported_reason = 'wrong_answer'
        """)
        
        cursor.execute("""
            UPDATE wrong_questions 
            SET reported_reason_new = 'بیش از یک جواب درست!' 
            WHERE reported_reason = 'multiple_correct'
        """)
        
        cursor.execute("""
            UPDATE wrong_questions 
            SET reported_reason_new = 'سایر' 
            WHERE reported_reason = 'other'
        """)
        
        # به‌روزرسانی مقادیر قدیمی که هنوز enum هستند
        cursor.execute("""
            UPDATE wrong_questions 
            SET reported_reason_new = 'سایر' 
            WHERE reported_reason IN ('grammar_error', 'typo', 'unclear', 'duplicate')
        """)
        
        # حذف ستون قدیمی
        print("حذف ستون قدیمی...")
        cursor.execute("ALTER TABLE wrong_questions DROP COLUMN reported_reason")
        
        # تغییر نام ستون جدید
        print("تغییر نام ستون جدید...")
        cursor.execute("""
            ALTER TABLE wrong_questions 
            CHANGE reported_reason_new reported_reason VARCHAR(255) DEFAULT 'سایر'
        """)
        
        # نمایش نتیجه
        print("\nنمایش نتیجه:")
        cursor.execute("SELECT reported_reason, COUNT(*) as count FROM wrong_questions GROUP BY reported_reason")
        results = cursor.fetchall()
        
        for reason, count in results:
            print(f"  {reason}: {count}")
        
        connection.commit()
        print("\n✅ Migration با موفقیت انجام شد!")
        
    except Exception as e:
        connection.rollback()
        print(f"❌ خطا در migration: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        cursor.close()
        connection.close()

if __name__ == "__main__":
    run_migration() 