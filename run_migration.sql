-- اجرای migration برای به‌روزرسانی enum values در جدول wrong_questions
USE firstsite;

-- ابتدا enum جدید را اضافه می‌کنیم
ALTER TABLE wrong_questions MODIFY COLUMN reported_reason ENUM('wrong_question', 'wrong_answer', 'multiple_correct', 'other') DEFAULT 'other';

-- به‌روزرسانی رکوردهای موجود
UPDATE wrong_questions SET reported_reason = 'wrong_question' WHERE reported_reason = 'grammar_error';
UPDATE wrong_questions SET reported_reason = 'wrong_answer' WHERE reported_reason = 'wrong_answer';
UPDATE wrong_questions SET reported_reason = 'multiple_correct' WHERE reported_reason = 'duplicate';
UPDATE wrong_questions SET reported_reason = 'other' WHERE reported_reason IN ('typo', 'unclear', 'other');

-- نمایش نتیجه
SELECT reported_reason, COUNT(*) as count FROM wrong_questions GROUP BY reported_reason; 