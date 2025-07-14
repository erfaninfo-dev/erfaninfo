-- ساخت جدول wrong_questions
CREATE TABLE IF NOT EXISTS wrong_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    question_text TEXT NOT NULL,
    options JSON NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    user_ip VARCHAR(45),
    quiz_name VARCHAR(255),
    content VARCHAR(255),
    question_type ENUM('general', 'personal') DEFAULT 'general',
    reported_reason ENUM('grammar_error', 'typo', 'unclear', 'wrong_answer', 'duplicate', 'other') DEFAULT 'other',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'reviewed', 'fixed', 'rejected') DEFAULT 'pending',
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_question_id (question_id),
    INDEX idx_question_type (question_type),
    INDEX idx_reported_reason (reported_reason)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; 