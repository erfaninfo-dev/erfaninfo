-- Migration: تغییر ستون question_type از ENUM به VARCHAR برای ذخیره کد آزمون یا مقدار دلخواه
USE erfan_db;
ALTER TABLE wrong_questions MODIFY COLUMN question_type VARCHAR(255) DEFAULT '';
-- نمایش نتیجه
SELECT question_type, COUNT(*) as count FROM wrong_questions GROUP BY question_type; 