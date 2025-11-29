-- اضافه کردن ستون‌های امنیتی جدید به جدول users
-- این کد را در MySQL Workbench یا phpMyAdmin اجرا کنید

USE erfaninfocom_example;

-- اضافه کردن ستون‌های جدید
ALTER TABLE users 
ADD COLUMN is_email_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN terms_accepted BOOLEAN DEFAULT FALSE,
ADD COLUMN terms_accepted_at DATETIME NULL,
ADD COLUMN last_login DATETIME NULL,
ADD COLUMN failed_login_attempts INT DEFAULT 0,
ADD COLUMN locked_until DATETIME NULL,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- تغییر ستون email به NOT NULL
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;

-- تغییر ستون password_hash به nullable (برای آینده)
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- اضافه کردن ایندکس‌ها برای بهبود عملکرد
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- آپدیت کاربران موجود برای پذیرش قوانین
UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;

-- نمایش ساختار نهایی جدول
DESCRIBE users;
