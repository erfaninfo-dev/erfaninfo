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
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_question_id (question_id)
); 