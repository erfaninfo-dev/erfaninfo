-- بررسی وضعیت دیتابیس
USE firstsite;

-- بررسی ساختار جدول
DESCRIBE wrong_questions;

-- بررسی enum values فعلی
SHOW COLUMNS FROM wrong_questions LIKE 'reported_reason';

-- نمایش گزارشات موجود
SELECT id, question_text, reported_reason, status, created_at 
FROM wrong_questions 
ORDER BY created_at DESC 
LIMIT 10;

-- بررسی تعداد گزارشات بر اساس دلیل
SELECT reported_reason, COUNT(*) as count 
FROM wrong_questions 
GROUP BY reported_reason; 