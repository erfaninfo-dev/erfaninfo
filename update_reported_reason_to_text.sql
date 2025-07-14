s-- Migration: تغییر ستون reported_reason از ENUM به VARCHAR برای ذخیره متن فارسی
USE firstsite;

-- ابتدا ستون جدید را اضافه می‌کنیم
ALTER TABLE wrong_questions ADD COLUMN reported_reason_new VARCHAR(255) DEFAULT 'سایر';

-- به‌روزرسانی مقادیر موجود
UPDATE wrong_questions SET reported_reason_new = 'سوال اشتباهه!' WHERE reported_reason = 'wrong_question';
UPDATE wrong_questions SET reported_reason_new = 'پاسخ درست اشتباهه!' WHERE reported_reason = 'wrong_answer';
UPDATE wrong_questions SET reported_reason_new = 'بیش از یک جواب درست!' WHERE reported_reason = 'multiple_correct';
UPDATE wrong_questions SET reported_reason_new = 'سایر' WHERE reported_reason = 'other';

-- حذف ستون قدیمی
ALTER TABLE wrong_questions DROP COLUMN reported_reason;

-- تغییر نام ستون جدید
ALTER TABLE wrong_questions CHANGE reported_reason_new reported_reason VARCHAR(255) DEFAULT 'سایر';

-- نمایش نتیجه
SELECT reported_reason, COUNT(*) as count FROM wrong_questions GROUP BY reported_reason; 