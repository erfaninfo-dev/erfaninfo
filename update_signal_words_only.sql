-- ویرایش کلمات نشانه - حذف تکرار در انگلیسی
-- ابتدا مقاله را پیدا می‌کنیم
SET @article_id = (SELECT id FROM articles WHERE title_fa LIKE '%Present Simple%' AND title_fa LIKE '%to be%' LIMIT 1);

-- اصلاح کلمات نشانه - در انگلیسی فقط یک بار (بدون تکرار)
UPDATE article_blocks 
SET 
    content_fa = 'always - همیشه\nusually - معمولاً\noften - اغلب\nsometimes - گاهی اوقات\nrarely - به ندرت\nnever - هرگز\nevery day - هر روز\non Mondays - دوشنبه‌ها',
    content_ku = 'always - هەمیشە\nusually - بەگشتی\noften - زۆر جار\nsometimes - هەندێک جار\nrarely - بە دەگمە\nnever - هەرگیز\nevery day - هەر ڕۆژێک\non Mondays - دووشەممەکان',
    content_en = 'always\nusually\noften\nsometimes\nrarely\nnever\nevery day\non Mondays'
WHERE article_id = @article_id 
AND block_type = 'list'
AND (content_en LIKE '%always - always%' OR content_en LIKE '%usually - usually%' OR content_en LIKE '%often - often%');

-- اصلاح مثال‌های کلمات نشانه - در انگلیسی فقط یک بار (بدون تکرار)
UPDATE article_blocks 
SET 
    content_fa = 'always - I am always happy. - من همیشه خوشحال هستم.\nusually - She is usually busy. - او معمولاً مشغول است.\noften - They are often late. - آنها اغلب دیر می‌رسند.\nsometimes - He is sometimes tired. - او گاهی اوقات خسته است.\nrarely - We are rarely sick. - ما به ندرت بیمار می‌شویم.\nnever - I am never angry. - من هرگز عصبانی نیستم.',
    content_ku = 'always - I am always happy. - من هەمیشە دڵخۆشم.\nusually - She is usually busy. - ئەو بەگشتی سەرقاڵە.\noften - They are often late. - ئەوان زۆر جار دواکەوتن.\nsometimes - He is sometimes tired. - ئەو هەندێک جار ماندووە.\nrarely - We are rarely sick. - ئێمە بە دەگمە نەخۆش دەبین.\nnever - I am never angry. - من هەرگیز توڕە نیم.',
    content_en = 'always - I am always happy. (Use: Feelings)\nusually - She is usually busy. (Use: Habits)\noften - They are often late. (Use: Frequency)\nsometimes - He is sometimes tired. (Use: Occasional)\nrarely - We are rarely sick. (Use: Infrequent)\nnever - I am never angry. (Use: Never)'
WHERE article_id = @article_id 
AND block_type = 'list'
AND (content_en LIKE '%I am always happy. (I am always happy.)%' OR content_en LIKE '%She is usually busy. (She is usually busy.)%');

-- نمایش نتیجه برای بررسی
SELECT 
    order_num,
    block_type,
    SUBSTRING(content_en, 1, 100) as content_en_preview
FROM article_blocks 
WHERE article_id = @article_id 
AND block_type = 'list'
ORDER BY order_num;
