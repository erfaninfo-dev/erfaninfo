-- ایجاد جدول wrong_questions
CREATE TABLE wrong_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    question_text TEXT NOT NULL,
    options JSON NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    user_ip VARCHAR(45),
    quiz_name VARCHAR(255),
    content VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'reviewed', 'fixed', 'rejected') DEFAULT 'pending',
    fa_explanation TEXT,
    kur_explanation TEXT,
    eng_explanation TEXT,
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_question_id (question_id)
); 

-- اختیاری: افزودن ستون توضیح انگلیسی به جداول سوالات موجود
ALTER TABLE questions ADD COLUMN IF NOT EXISTS eng_explanation TEXT NULL;
ALTER TABLE student_quiz ADD COLUMN IF NOT EXISTS eng_explanation TEXT NULL;