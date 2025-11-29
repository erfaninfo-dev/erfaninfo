-- ایجاد جدول مقالات
CREATE TABLE articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title_fa VARCHAR(255) NOT NULL COMMENT 'عنوان فارسی',
    title_ku VARCHAR(255) NOT NULL COMMENT 'عنوان کوردی',
    title_en VARCHAR(255) NOT NULL COMMENT 'عنوان انگلیسی',
    content_fa TEXT NOT NULL COMMENT 'محتوای کامل فارسی',
    content_ku TEXT NOT NULL COMMENT 'محتوای کامل کوردی',
    content_en TEXT NOT NULL COMMENT 'محتوای کامل انگلیسی',
    tags_fa VARCHAR(500) COMMENT 'تگ‌های فارسی (جدا شده با کاما)',
    tags_ku VARCHAR(500) COMMENT 'تگ‌های کوردی (جدا شده با کاما)',
    tags_en VARCHAR(500) COMMENT 'تگ‌های انگلیسی (جدا شده با کاما)',
    views INT DEFAULT 0 COMMENT 'تعداد بازدید',
    is_published BOOLEAN DEFAULT TRUE COMMENT 'منتشر شده یا نه',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'تاریخ ایجاد',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'تاریخ به‌روزرسانی',
    author_id INT COMMENT 'نویسنده مقاله (مرجع به جدول users)',
    category VARCHAR(100) COMMENT 'دسته‌بندی (گرامر، واژگان، و...)',
    reading_time INT COMMENT 'زمان مطالعه (دقیقه)',
    
    -- ایندکس‌ها برای بهبود عملکرد
    INDEX idx_published (is_published),
    INDEX idx_created_at (created_at),
    INDEX idx_category (category),
    INDEX idx_author (author_id),
    INDEX idx_views (views),
    
    -- کلید خارجی برای نویسنده
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='جدول مقالات سه‌زبانه';

-- اضافه کردن ایندکس‌های اضافی برای جستجو
CREATE FULLTEXT INDEX ft_title_fa ON articles(title_fa);
CREATE FULLTEXT INDEX ft_content_fa ON articles(content_fa);
CREATE FULLTEXT INDEX ft_title_ku ON articles(title_ku);
CREATE FULLTEXT INDEX ft_content_ku ON articles(content_ku);
CREATE FULLTEXT INDEX ft_title_en ON articles(title_en);
CREATE FULLTEXT INDEX ft_content_en ON articles(content_en);
