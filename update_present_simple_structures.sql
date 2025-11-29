-- ویرایش ساختارهای موجود در مقاله Present Simple
-- ابتدا مقاله را پیدا می‌کنیم
SET @article_id = (SELECT id FROM articles WHERE title_fa LIKE '%Present Simple%' AND title_fa LIKE '%to be%' LIMIT 1);

-- اگر مقاله پیدا شد، ساختارها را ویرایش می‌کنیم
UPDATE article_blocks 
SET 
    content_fa = 'Subject + to be + Complement\nExample: I am a student.',
    content_ku = 'Subject + to be + Complement\nExample: I am a student.',
    content_en = 'Structure: Subject + to be + Complement\nExample: I am a student.'
WHERE article_id = @article_id 
AND order_num = 11 
AND block_type = 'code';

UPDATE article_blocks 
SET 
    content_fa = 'Subject + to be + not + Complement\nExample: I am not tired.',
    content_ku = 'Subject + to be + not + Complement\nExample: I am not tired.',
    content_en = 'Structure: Subject + to be + not + Complement\nExample: I am not tired.'
WHERE article_id = @article_id 
AND order_num = 19 
AND block_type = 'code';

UPDATE article_blocks 
SET 
    content_fa = 'To be + Subject + Complement?\nExample: Are you ready?',
    content_ku = 'To be + Subject + Complement?\nExample: Are you ready?',
    content_en = 'Structure: To be + Subject + Complement?\nExample: Are you ready?'
WHERE article_id = @article_id 
AND order_num = 27 
AND block_type = 'code';

-- حذف ترجمه‌های فارسی از ساختار to be (order_num = 7)
UPDATE article_blocks 
SET 
    content_fa = 'I am\nYou are\nHe/She/It is\nWe are\nYou are\nThey are',
    content_ku = 'I am\nYou are\nHe/She/It is\nWe are\nYou are\nThey are',
    content_en = 'I am\nYou are\nHe/She/It is\nWe are\nYou are\nThey are'
WHERE article_id = @article_id 
AND order_num = 7 
AND block_type = 'code';

-- اطمینان از اینکه همه ساختارها در همه زبان‌ها انگلیسی باشند
UPDATE article_blocks 
SET 
    content_fa = 'Subject + to be + Complement\nExample: I am a student.',
    content_ku = 'Subject + to be + Complement\nExample: I am a student.',
    content_en = 'Structure: Subject + to be + Complement\nExample: I am a student.'
WHERE article_id = @article_id 
AND order_num = 11 
AND block_type = 'code';

UPDATE article_blocks 
SET 
    content_fa = 'Subject + to be + not + Complement\nExample: I am not tired.',
    content_ku = 'Subject + to be + not + Complement\nExample: I am not tired.',
    content_en = 'Structure: Subject + to be + not + Complement\nExample: I am not tired.'
WHERE article_id = @article_id 
AND order_num = 19 
AND block_type = 'code';

UPDATE article_blocks 
SET 
    content_fa = 'To be + Subject + Complement?\nExample: Are you ready?',
    content_ku = 'To be + Subject + Complement?\nExample: Are you ready?',
    content_en = 'Structure: To be + Subject + Complement?\nExample: Are you ready?'
WHERE article_id = @article_id 
AND order_num = 27 
AND block_type = 'code';

-- اصلاح مثال‌ها برای LTR در همه زبان‌ها - در انگلیسی فقط یک بار
UPDATE article_blocks 
SET 
    content_fa = 'I am happy. - من خوشحال هستم. (کاربرد: احساسات)',
    content_ku = 'I am happy. - من دڵخۆشم. (بەکارهێنان: هەست)',
    content_en = 'I am happy. (Use: Feelings)'
WHERE article_id = @article_id 
AND order_num = 12 
AND block_type = 'example';

UPDATE article_blocks 
SET 
    content_fa = 'She is a doctor. - او پزشک است. (کاربرد: حرفه)',
    content_ku = 'She is a doctor. - ئەو دکتۆرە. (بەکارهێنان: پیشە)',
    content_en = 'She is a doctor. (Use: Profession)'
WHERE article_id = @article_id 
AND order_num = 13 
AND block_type = 'example';

UPDATE article_blocks 
SET 
    content_fa = 'They are students. - آنها دانشجو هستند. (کاربرد: هویت)',
    content_ku = 'They are students. - ئەوان قوتابیین. (بەکارهێنان: ناسنامە)',
    content_en = 'They are students. (Use: Identity)'
WHERE article_id = @article_id 
AND order_num = 14 
AND block_type = 'example';

UPDATE article_blocks 
SET 
    content_fa = 'We are in Tehran. - ما در تهران هستیم. (کاربرد: موقعیت)',
    content_ku = 'We are in Tehran. - ئێمە لە تەهرانین. (بەکارهێنان: شوێن)',
    content_en = 'We are in Tehran. (Use: Location)'
WHERE article_id = @article_id 
AND order_num = 15 
AND block_type = 'example';

UPDATE article_blocks 
SET 
    content_fa = 'It is cold today. - امروز سرد است. (کاربرد: شرایط)',
    content_ku = 'It is cold today. - ئەمڕۆ ساردە. (بەکارهێنان: دۆخ)',
    content_en = 'It is cold today. (Use: Condition)'
WHERE article_id = @article_id 
AND order_num = 16 
AND block_type = 'example';

-- اصلاح کلمات نشانه - در انگلیسی فقط یک بار
UPDATE article_blocks 
SET 
    content_fa = 'always - همیشه\nusually - معمولاً\noften - اغلب\nsometimes - گاهی اوقات\nrarely - به ندرت\nnever - هرگز\nevery day - هر روز\non Mondays - دوشنبه‌ها',
    content_ku = 'always - هەمیشە\nusually - بەگشتی\noften - زۆر جار\nsometimes - هەندێک جار\nrarely - بە دەگمە\nnever - هەرگیز\nevery day - هەر ڕۆژێک\non Mondays - دووشەممەکان',
    content_en = 'always\nusually\noften\nsometimes\nrarely\nnever\nevery day\non Mondays'
WHERE article_id = @article_id 
AND order_num = 8 
AND block_type = 'list';

-- اضافه کردن مثال‌های کلمات نشانه با to be verbs
UPDATE article_blocks 
SET 
    content_fa = 'always - I am always happy. - من همیشه خوشحال هستم.\nusually - She is usually busy. - او معمولاً مشغول است.\noften - They are often late. - آنها اغلب دیر می‌رسند.\nsometimes - He is sometimes tired. - او گاهی اوقات خسته است.\nrarely - We are rarely sick. - ما به ندرت بیمار می‌شویم.\nnever - I am never angry. - من هرگز عصبانی نیستم.',
    content_ku = 'always - I am always happy. - من هەمیشە دڵخۆشم.\nusually - She is usually busy. - ئەو بەگشتی سەرقاڵە.\noften - They are often late. - ئەوان زۆر جار دواکەوتن.\nsometimes - He is sometimes tired. - ئەو هەندێک جار ماندووە.\nrarely - We are rarely sick. - ئێمە بە دەگمە نەخۆش دەبین.\nnever - I am never angry. - من هەرگیز توڕە نیم.',
    content_en = 'always - I am always happy.\nusually - She is usually busy.\noften - They are often late.\nsometimes - He is sometimes tired.\nrarely - We are rarely sick.\nnever - I am never angry.'
WHERE article_id = @article_id 
AND order_num = 9 
AND block_type = 'list';

-- نمایش نتیجه
SELECT 
    order_num,
    block_type,
    content_fa,
    content_ku,
    content_en
FROM article_blocks 
WHERE article_id = @article_id 
AND (block_type = 'code' OR block_type = 'example' OR block_type = 'list')
ORDER BY order_num;
