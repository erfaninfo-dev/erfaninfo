-- Update the reported_reason enum values in wrong_questions table
-- First, add the new enum values
ALTER TABLE wrong_questions MODIFY COLUMN reported_reason ENUM('wrong_question', 'wrong_answer', 'multiple_correct', 'other') DEFAULT 'other';

-- Update existing records to use the new enum values
-- Map old values to new ones
UPDATE wrong_questions SET reported_reason = 'wrong_question' WHERE reported_reason = 'grammar_error';
UPDATE wrong_questions SET reported_reason = 'wrong_answer' WHERE reported_reason = 'wrong_answer';
UPDATE wrong_questions SET reported_reason = 'multiple_correct' WHERE reported_reason = 'duplicate';
UPDATE wrong_questions SET reported_reason = 'other' WHERE reported_reason IN ('typo', 'unclear', 'other'); 