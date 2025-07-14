-- اضافه کردن ستون question_type به جدول wrong_questions موجود
ALTER TABLE wrong_questions 
ADD COLUMN question_type ENUM('general', 'personal') DEFAULT 'general' 
AFTER content;
 
-- اضافه کردن index برای ستون جدید
ALTER TABLE wrong_questions 
ADD INDEX idx_question_type (question_type); 