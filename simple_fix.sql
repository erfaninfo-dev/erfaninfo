-- کپی کنید و اجرا کنید:

-- حل مشکل ایمیل‌های خالی
UPDATE users SET email = CONCAT('temp_', username, '@example.com') WHERE email = '' OR email IS NULL;

-- تغییر ستون‌ها
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- اضافه کردن ایندکس‌ها
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- آپدیت کاربران موجود
UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;
