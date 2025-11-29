-- حذف مقالات تکراری با ID 4 و 5
-- ابتدا بلاک‌های مربوط به این مقالات را حذف می‌کنیم
DELETE FROM article_blocks WHERE article_id IN (4, 5);

-- سپس خود مقالات را حذف می‌کنیم
DELETE FROM articles WHERE id IN (4, 5);

-- بررسی نتیجه
SELECT 'مقالات حذف شده:' as message;
SELECT id, title_fa, title_ku, title_en FROM articles WHERE id IN (4, 5);

-- نمایش تعداد باقی‌مانده
SELECT 'تعداد مقالات باقی‌مانده:' as message, COUNT(*) as count FROM articles;
SELECT 'تعداد بلاک‌های باقی‌مانده:' as message, COUNT(*) as count FROM article_blocks;
