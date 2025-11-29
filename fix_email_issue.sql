-- حل مشکل ایمیل‌های خالی قبل از تغییر ستون

-- مرحله 1: بررسی کاربران با ایمیل خالی
SELECT id, username, email FROM users WHERE email = '' OR email IS NULL;

-- مرحله 2: آپدیت کاربران با ایمیل خالی (اضافه کردن ایمیل موقت)
UPDATE users 
SET email = CONCAT('temp_', username, '@example.com') 
WHERE email = '' OR email IS NULL;

-- مرحله 3: بررسی مجدد
SELECT id, username, email FROM users WHERE email LIKE 'temp_%';

-- مرحله 4: حالا می‌توانیم ستون email را به NOT NULL تغییر دهیم
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;

-- مرحله 5: تغییر ستون password_hash
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- مرحله 6: اضافه کردن ایندکس‌ها
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- مرحله 7: آپدیت کاربران موجود برای پذیرش قوانین
UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;

-- مرحله 8: نمایش نتیجه نهایی
DESCRIBE users;
