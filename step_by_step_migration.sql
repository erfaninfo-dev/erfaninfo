-- مرحله 1: اضافه کردن ستون‌های جدید
ALTER TABLE users 
ADD COLUMN is_email_verified BOOLEAN DEFAULT FALSE;

ALTER TABLE users 
ADD COLUMN terms_accepted BOOLEAN DEFAULT FALSE;

ALTER TABLE users 
ADD COLUMN terms_accepted_at DATETIME NULL;

ALTER TABLE users 
ADD COLUMN last_login DATETIME NULL;

ALTER TABLE users 
ADD COLUMN failed_login_attempts INT DEFAULT 0;

ALTER TABLE users 
ADD COLUMN locked_until DATETIME NULL;

ALTER TABLE users 
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- مرحله 2: تغییر ستون‌های موجود
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- مرحله 3: اضافه کردن ایندکس‌ها
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- مرحله 4: آپدیت داده‌های موجود
UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;

-- مرحله 5: بررسی نتیجه
SELECT * FROM users LIMIT 1;
DESCRIBE users;
