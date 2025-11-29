-- اضافه کردن فقط ستون‌های مفقود (بدون خطای duplicate)

-- بررسی و اضافه کردن ستون‌ها (اگر وجود ندارند)
SET @sql = 'ALTER TABLE users ADD COLUMN is_email_verified BOOLEAN DEFAULT FALSE';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'is_email_verified') = 0, @sql, 'SELECT "Column is_email_verified already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN terms_accepted BOOLEAN DEFAULT FALSE';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'terms_accepted') = 0, @sql, 'SELECT "Column terms_accepted already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN terms_accepted_at DATETIME NULL';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'terms_accepted_at') = 0, @sql, 'SELECT "Column terms_accepted_at already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN last_login DATETIME NULL';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'last_login') = 0, @sql, 'SELECT "Column last_login already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN failed_login_attempts INT DEFAULT 0';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'failed_login_attempts') = 0, @sql, 'SELECT "Column failed_login_attempts already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN locked_until DATETIME NULL';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'locked_until') = 0, @sql, 'SELECT "Column locked_until already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE users ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP';
SET @sql = IF((SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'updated_at') = 0, @sql, 'SELECT "Column updated_at already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- تغییر ستون‌های موجود
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

-- اضافه کردن ایندکس‌ها (اگر وجود ندارند)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- آپدیت کاربران موجود
UPDATE users SET terms_accepted = TRUE, terms_accepted_at = NOW() WHERE terms_accepted IS NULL;

-- نمایش نتیجه نهایی
DESCRIBE users;
