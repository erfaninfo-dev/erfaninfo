#!/usr/bin/env python3
"""
اسکریپت اجرای migration برای آپدیت جدول users
"""

import mysql.connector
import os
from dotenv import load_dotenv

# بارگذاری متغیرهای محیطی
load_dotenv()

def run_migration():
    try:
        # اتصال به دیتابیس
        connection = mysql.connector.connect(
            host=os.getenv('MYSQL_HOST', 'localhost'),
            user=os.getenv('MYSQL_USER', 'root'),
            password=os.getenv('MYSQL_PASSWORD', ''),
            database=os.getenv('MYSQL_DB', 'erfaninfocom_example'),
            charset='utf8mb4'
        )
        
        cursor = connection.cursor()
        
        print("🔗 اتصال به دیتابیس برقرار شد")
        
        # اجرای دستورات migration
        migration_commands = [
            # اضافه کردن ستون‌های جدید
            """
            ALTER TABLE users 
            ADD COLUMN is_email_verified BOOLEAN DEFAULT FALSE,
            ADD COLUMN terms_accepted BOOLEAN DEFAULT FALSE,
            ADD COLUMN terms_accepted_at DATETIME NULL,
            ADD COLUMN last_login DATETIME NULL,
            ADD COLUMN failed_login_attempts INT DEFAULT 0,
            ADD COLUMN locked_until DATETIME NULL,
            ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
            """,
            
            # تغییر ستون email به NOT NULL
            "ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;",
            
            # تغییر ستون password_hash به nullable
            "ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;",
            
            # اضافه کردن ایندکس‌ها
            "CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);",
            "CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);",
            
            # آپدیت کاربران موجود
            "UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;"
        ]
        
        for i, command in enumerate(migration_commands, 1):
            try:
                print(f"⏳ اجرای دستور {i}/{len(migration_commands)}...")
                cursor.execute(command)
                connection.commit()
                print(f"✅ دستور {i} با موفقیت اجرا شد")
            except mysql.connector.Error as e:
                if e.errno == 1060:  # Duplicate column name
                    print(f"⚠️  ستون قبلاً وجود دارد - دستور {i} رد شد")
                elif e.errno == 1061:  # Duplicate key name
                    print(f"⚠️  ایندکس قبلاً وجود دارد - دستور {i} رد شد")
                else:
                    print(f"❌ خطا در دستور {i}: {e}")
                    raise
        
        # نمایش ساختار نهایی جدول
        print("\n📋 ساختار نهایی جدول users:")
        cursor.execute("DESCRIBE users;")
        columns = cursor.fetchall()
        
        for column in columns:
            print(f"  - {column[0]}: {column[1]} {'NULL' if column[2] == 'YES' else 'NOT NULL'}")
        
        print("\n🎉 Migration با موفقیت تکمیل شد!")
        
    except mysql.connector.Error as e:
        print(f"❌ خطا در اتصال به دیتابیس: {e}")
        return False
    except Exception as e:
        print(f"❌ خطای غیرمنتظره: {e}")
        return False
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            print("🔌 اتصال به دیتابیس بسته شد")
    
    return True

if __name__ == "__main__":
    print("🚀 شروع Migration جدول users...")
    success = run_migration()
    
    if success:
        print("\n✅ Migration تکمیل شد! حالا می‌توانید سیستم ثبت نام امن را استفاده کنید.")
    else:
        print("\n❌ Migration ناموفق بود. لطفاً خطاها را بررسی کنید.")