-- بررسی وضعیت فعلی جدول users
DESCRIBE users;

-- بررسی وجود ستون‌های جدید
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'erfaninfocom_example' 
AND TABLE_NAME = 'users'
ORDER BY ORDINAL_POSITION;
