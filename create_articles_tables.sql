-- حذف جدول‌ها در صورت وجود
DROP TABLE IF EXISTS article_blocks;
DROP TABLE IF EXISTS articles;

-- ایجاد جدول مقالات اصلی
CREATE TABLE articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title_fa VARCHAR(255) NOT NULL COMMENT 'عنوان فارسی',
    title_ku VARCHAR(255) NOT NULL COMMENT 'عنوان کوردی',
    title_en VARCHAR(255) NOT NULL COMMENT 'عنوان انگلیسی',
    excerpt_fa TEXT COMMENT 'خلاصه فارسی (3 خط اول)',
    excerpt_ku TEXT COMMENT 'خلاصه کوردی (3 خط اول)',
    excerpt_en TEXT COMMENT 'خلاصه انگلیسی (3 خط اول)',
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
    featured_image VARCHAR(500) COMMENT 'تصویر شاخص مقاله',
    
    -- ایندکس‌ها
    INDEX idx_published (is_published),
    INDEX idx_created_at (created_at),
    INDEX idx_category (category),
    INDEX idx_author (author_id),
    INDEX idx_views (views)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='جدول مقالات';

-- ایجاد جدول بخش‌های مقالات
CREATE TABLE article_blocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL COMMENT 'مرجع به جدول articles',
    block_type ENUM(
        'paragraph',    -- متن معمولی
        'example',      -- مثال
        'note',         -- نکته مهم
        'image',        -- عکس
        'subtitle',     -- تیتر کوچک
        'video',        -- ویدیو
        'audio',        -- فایل صوتی
        'file',         -- فایل (PDF, DOC)
        'quote',        -- نقل قول
        'code',         -- کد برنامه‌نویسی
        'table',        -- جدول
        'list',         -- لیست (ul/ol)
        'divider',      -- خط جداکننده
        'callout',      -- کادر ویژه
        'exercise',     -- تمرین
        'vocabulary'    -- واژگان
    ) NOT NULL COMMENT 'نوع بلاک',
    content_fa TEXT COMMENT 'محتوای فارسی',
    content_ku TEXT COMMENT 'محتوای کوردی',
    content_en TEXT COMMENT 'محتوای انگلیسی',
    order_num INT NOT NULL DEFAULT 0 COMMENT 'ترتیب نمایش',
    block_metadata JSON COMMENT 'اطلاعات اضافی (اندازه عکس، لینک ویدیو، و...)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'فعال یا غیرفعال',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- ایندکس‌ها
    INDEX idx_article_order (article_id, order_num),
    INDEX idx_block_type (block_type),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='جدول بخش‌های مقالات';

-- اضافه کردن ایندکس‌های Fulltext برای جستجو
CREATE FULLTEXT INDEX ft_articles_title_fa ON articles(title_fa);
CREATE FULLTEXT INDEX ft_articles_excerpt_fa ON articles(excerpt_fa);
CREATE FULLTEXT INDEX ft_blocks_content_fa ON article_blocks(content_fa);
