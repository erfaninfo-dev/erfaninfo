-- مقاله جامع Present Simple
INSERT INTO articles (
    title_fa, 
    title_ku, 
    title_en, 
    excerpt_fa, 
    excerpt_ku, 
    excerpt_en, 
    tags_fa, 
    tags_ku, 
    tags_en, 
    category, 
    reading_time,
    is_published
) VALUES (
    '📚 گرامر Present Simple: راهنمای کامل',
    '📚 گرامەری Present Simple: ڕێنمایی تەواو',
    '📚 Present Simple Grammar: Complete Guide',
    'در این مقاله به بررسی جامع گرامر Present Simple می‌پردازیم. این زمان یکی از پایه‌ای‌ترین زمان‌های انگلیسی است که برای بیان عادات، حقایق و روال‌های روزمره استفاده می‌شود.',
    'لەم وتارەدا بەدوادا دەکەین بۆ گرامەری تەواوی Present Simple. ئەم کاتە یەکێکە لە بنەڕەتیترین کاتەکانی ئینگلیزی کە بۆ باسکردنی خوو، ڕاستی و ڕەوەڕەوە ڕۆژانەکان بەکاردەهێنرێت.',
    'In this article, we examine the comprehensive grammar of Present Simple. This tense is one of the most fundamental English tenses used to express habits, facts, and daily routines.',
    'گرامر,Present Simple,زمان انگلیسی,آموزش',
    'گرامەر,Present Simple,زمانی ئینگلیزی,فێرکاری',
    'grammar,present simple,english tenses,learning',
    'گرامر',
    15,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'Present Simple چیست؟', 'Present Simple چییە؟', 'What is Present Simple?', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'Present Simple یکی از مهم‌ترین زمان‌های انگلیسی است که برای بیان عادات، حقایق، روال‌های روزمره و شرایط دائمی استفاده می‌شود. این زمان پایه و اساس یادگیری زبان انگلیسی است و در مکالمات روزمره بسیار پرکاربرد است.', 'Present Simple یەکێکە لە گرنگترین کاتەکانی ئینگلیزی کە بۆ باسکردنی خوو، ڕاستی، ڕەوەڕەوە ڕۆژانەکان و دۆخە بەردەوامەکان بەکاردەهێنرێت. ئەم کاتە بنەڕەت و پێکهاتەی فێربوونی زمانی ئینگلیزییە و لە گفتوگۆی ڕۆژانەدا زۆر بەکارهێنراوە.', 'Present Simple is one of the most important English tenses used to express habits, facts, daily routines, and permanent conditions. This tense is the foundation of English language learning and is very commonly used in daily conversations.', 2),

-- تیتر کاربردها
(@article_id, 'subtitle', 'کاربردهای Present Simple', 'بەکارهێنانەکانی Present Simple', 'Uses of Present Simple', 3),

-- لیست کاربردها
(@article_id, 'list', 'عادات و روال‌های روزمره\nحقایق و اطلاعات عمومی\nبرنامه‌های ثابت (مثل برنامه قطار)\nاحساسات و عقاید\nشرایط دائمی و علمی', 'خوو و ڕەوەڕەوە ڕۆژانەکان\nڕاستی و زانیاری گشتی\nپڕۆگرامە بەردەوامەکان (وەک پڕۆگرامی شەمەندەفەر)\nهەست و بۆچوونەکان\nدۆخە بەردەوام و زانستییەکان', 'Daily habits and routines\nGeneral facts and information\nFixed schedules (like train timetables)\nFeelings and opinions\nPermanent and scientific conditions', 4),

-- تیتر ساختار
(@article_id, 'subtitle', 'ساختار Present Simple', 'پێکهاتەی Present Simple', 'Structure of Present Simple', 5),

-- کد ساختار
(@article_id, 'code', 'Affirmative: Subject + Base Verb (+s for 3rd person singular)\nNegative: Subject + do/does + not + Base Verb\nQuestion: Do/Does + Subject + Base Verb?', 'Affirmative: Subject + Base Verb (+s for 3rd person singular)\nNegative: Subject + do/does + not + Base Verb\nQuestion: Do/Does + Subject + Base Verb?', 'Affirmative: Subject + Base Verb (+s for 3rd person singular)\nNegative: Subject + do/does + not + Base Verb\nQuestion: Do/Does + Subject + Base Verb?', 6),

-- نکته مهم
(@article_id, 'note', 'برای فاعل‌های سوم شخص مفرد (he, she, it) حرف "s" به انتهای فعل اضافه می‌شود. برای مثال: He works, She plays, It runs.', 'بۆ فاعلە سێیەم کەسە تاکەکان (he, she, it) پیت "s" لە کۆتایی کردار زیاد دەکرێت. بۆ نموونە: He works, She plays, It runs.', 'For third person singular subjects (he, she, it), the letter "s" is added to the end of the verb. For example: He works, She plays, It runs.', 7),

-- تیتر مثال‌های مثبت
(@article_id, 'subtitle', 'مثال‌های مثبت', 'نموونەکانی ئەرێنی', 'Affirmative Examples', 8),

-- مثال‌های مثبت
(@article_id, 'example', 'I work in a hospital. - من در بیمارستان کار می‌کنم.', 'I work in a hospital. - من لە نەخۆشخانە کار دەکەم.', 'I work in a hospital. - I work in a hospital.', 9),

(@article_id, 'example', 'You study English every day. - تو هر روز انگلیسی مطالعه می‌کنی.', 'You study English every day. - تۆ هەر ڕۆژ ئینگلیزی دەخوێنیتەوە.', 'You study English every day. - You study English every day.', 10),

(@article_id, 'example', 'He plays football on weekends. - او آخر هفته فوتبال بازی می‌کند.', 'He plays football on weekends. - ئەو لە کۆتایی هەفتەدا تۆپی پێ یاری دەکات.', 'He plays football on weekends. - He plays football on weekends.', 11),

(@article_id, 'example', 'She teaches mathematics. - او ریاضی تدریس می‌کند.', 'She teaches mathematics. - ئەو بیرکاری فێردەکات.', 'She teaches mathematics. - She teaches mathematics.', 12),

(@article_id, 'example', 'We live in Tehran. - ما در تهران زندگی می‌کنیم.', 'We live in Tehran. - ئێمە لە تەهران دەژین.', 'We live in Tehran. - We live in Tehran.', 13),

-- تیتر مثال‌های منفی
(@article_id, 'subtitle', 'مثال‌های منفی', 'نموونەکانی نەرێنی', 'Negative Examples', 14),

-- مثال‌های منفی
(@article_id, 'example', 'I do not (don\'t) like coffee. - من قهوه دوست ندارم.', 'I do not (don\'t) like coffee. - من قاوە خۆشم نایەت.', 'I do not (don\'t) like coffee. - I do not (don\'t) like coffee.', 15),

(@article_id, 'example', 'You do not (don\'t) speak French. - تو فرانسوی صحبت نمی‌کنی.', 'You do not (don\'t) speak French. - تۆ فەرەنسی قسە ناکەیت.', 'You do not (don\'t) speak French. - You do not (don\'t) speak French.', 16),

(@article_id, 'example', 'He does not (doesn\'t) watch TV. - او تلویزیون تماشا نمی‌کند.', 'He does not (doesn\'t) watch TV. - ئەو تەلەڤیزیۆن نەدەبینێت.', 'He does not (doesn\'t) watch TV. - He does not (doesn\'t) watch TV.', 17),

(@article_id, 'example', 'She does not (doesn\'t) drive a car. - او رانندگی نمی‌کند.', 'She does not (doesn\'t) drive a car. - ئەو شۆفێری ناکات.', 'She does not (doesn\'t) drive a car. - She does not (doesn\'t) drive a car.', 18),

(@article_id, 'example', 'They do not (don\'t) eat meat. - آنها گوشت نمی‌خورند.', 'They do not (don\'t) eat meat. - ئەوان گۆشت ناخۆن.', 'They do not (don\'t) eat meat. - They do not (don\'t) eat meat.', 19),

-- تیتر مثال‌های سوالی
(@article_id, 'subtitle', 'مثال‌های سوالی', 'نموونەکانی پرسیار', 'Interrogative Examples', 20),

-- مثال‌های سوالی
(@article_id, 'example', 'Do you speak English? - آیا تو انگلیسی صحبت می‌کنی؟', 'Do you speak English? - ئایا تۆ ئینگلیزی قسە دەکەیت؟', 'Do you speak English? - Do you speak English?', 21),

(@article_id, 'example', 'Does he work here? - آیا او اینجا کار می‌کند؟', 'Does he work here? - ئایا ئەو لێرە کار دەکات؟', 'Does he work here? - Does he work here?', 22),

(@article_id, 'example', 'Do they live in London? - آیا آنها در لندن زندگی می‌کنند؟', 'Do they live in London? - ئایا ئەوان لە لەندەن دەژین؟', 'Do they live in London? - Do they live in London?', 23),

(@article_id, 'example', 'Does she like music? - آیا او موسیقی دوست دارد؟', 'Does she like music? - ئایا ئەو مۆسیقا خۆشدەوێت؟', 'Does she like music? - Does she like music?', 24),

(@article_id, 'example', 'Do we need to study? - آیا ما باید مطالعه کنیم؟', 'Do we need to study? - ئایا ئێمە پێویستمان بە خوێندنەوەیە؟', 'Do we need to study? - Do we need to study?', 25),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 26),

-- تیتر کلمات نشانه
(@article_id, 'subtitle', 'کلمات نشانه Present Simple', 'وشە نیشاندەرەکانی Present Simple', 'Present Simple Signal Words', 27),

-- لیست کلمات نشانه
(@article_id, 'list', 'always - همیشه\nusually - معمولاً\noften - اغلب\nsometimes - گاهی\nrarely - به ندرت\nnever - هرگز\nevery day - هر روز\nevery week - هر هفته\nevery month - هر ماه\nevery year - هر سال\non Mondays - دوشنبه‌ها\nat weekends - آخر هفته‌ها', 'always - هەمیشە\nusually - بەگشتی\noften - زۆربەی کات\nsometimes - هەندێک جار\nrarely - بە دەگمە\nnever - هەرگیز\nevery day - هەر ڕۆژ\nevery week - هەر هەفتە\nevery month - هەر مانگ\nevery year - هەر ساڵ\non Mondays - دووشەممەکان\nat weekends - کۆتایی هەفتەکان', 'always - always\nusually - usually\noften - often\nsometimes - sometimes\nrarely - rarely\nnever - never\nevery day - every day\nevery week - every week\nevery month - every month\nevery year - every year\non Mondays - on Mondays\nat weekends - at weekends', 28),

-- نکته مهم
(@article_id, 'note', 'این کلمات نشانه به شما کمک می‌کنند تا تشخیص دهید که باید از Present Simple استفاده کنید. وقتی این کلمات را می‌بینید، مطمئن باشید که باید از این زمان استفاده کنید.', 'ئەم وشە نیشاندەرانە یارمەتیت دەدەن تا دیاری بکەیت کە دەبێت لە Present Simple بەکاربێنیت. کاتێک ئەم وشانە دەبینیت، دڵنیا بە کە دەبێت لەم کاتە بەکاربێنیت.', 'These signal words help you identify when to use Present Simple. When you see these words, be sure to use this tense.', 29),

-- تیتر اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵە باوەکان', 'Common Mistakes', 30),

-- لیست اشتباهات
(@article_id, 'list', 'فراموش کردن "s" برای سوم شخص مفرد\nاستفاده نادرست از "do/does" در جملات مثبت\nاستفاده از "am/is/are" به جای فعل اصلی\nفراموش کردن "do/does" در جملات منفی\nاستفاده نادرست از کلمات نشانه', 'لەبیرکردنی "s" بۆ سێیەم کەسە تاکەکان\nبەکارهێنانی هەڵەی "do/does" لە جملە ئەرێنییەکان\nبەکارهێنانی "am/is/are" لەجیاتی کرداری سەرەکی\nلەبیرکردنی "do/does" لە جملە نەرێنییەکان\nبەکارهێنانی هەڵەی وشە نیشاندەرەکان', 'Forgetting "s" for third person singular\nIncorrect use of "do/does" in affirmative sentences\nUsing "am/is/are" instead of main verb\nForgetting "do/does" in negative sentences\nIncorrect use of signal words', 31),

-- نکته مهم
(@article_id, 'note', 'برای جلوگیری از این اشتباهات، همیشه به یاد داشته باشید که برای سوم شخص مفرد "s" اضافه کنید و در جملات منفی و سوالی از "do/does" استفاده کنید.', 'بۆ ڕێگریکردن لەم هەڵانە، هەمیشە لەبیرت بێت کە بۆ سێیەم کەسە تاکەکان "s" زیاد بکەیت و لە جملە نەرێنی و پرسیارەکان لە "do/does" بەکاربێنیت.', 'To avoid these mistakes, always remember to add "s" for third person singular and use "do/does" in negative and interrogative sentences.', 32),

-- تیتر نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی برای تسلط', 'خاڵە بەکارهێنراوەکان بۆ لێهاتوویی', 'Practical Tips for Mastery', 33),

-- لیست نکات کاربردی
(@article_id, 'list', 'هر روز جملات Present Simple بسازید\nاز کلمات نشانه استفاده کنید\nبا خودتان صحبت کنید\nمکالمات روزمره را تمرین کنید\nاز کتاب‌های آموزشی استفاده کنید', 'هەر ڕۆژ جملە Present Simple دروست بکە\nلە وشە نیشاندەرەکان بەکاربێنە\nلەگەڵ خۆت قسە بکە\nگفتوگۆی ڕۆژانە ڕاهێنان بکە\nلە کتێبە فێرکارییەکان بەکاربێنە', 'Make Present Simple sentences every day\nUse signal words\nTalk to yourself\nPractice daily conversations\nUse educational books', 34),

-- نقل قول
(@article_id, 'quote', 'Present Simple پایه و اساس زبان انگلیسی است. تسلط بر این زمان کلید موفقیت در یادگیری زبان است.', 'Present Simple بنەڕەت و پێکهاتەی زمانی ئینگلیزییە. لێهاتوویی لەم کاتە کلیلی سەرکەوتنە لە فێربوونی زمان.', 'Present Simple is the foundation of English. Mastering this tense is the key to success in language learning.', 35),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای یادگیری بهتر Present Simple، سعی کنید جملات روزمره خود را با این زمان بسازید و در مکالمات روزانه استفاده کنید. تمرین مداوم کلید موفقیت است.', '💡 خاڵ: بۆ فێربوونی باشتری Present Simple، هەوڵ بدە جملە ڕۆژانەکانت بەم کاتە دروست بکەیت و لە گفتوگۆی ڕۆژانەدا بەکاربێنیت. ڕاهێنانی بەردەوام کلیلی سەرکەوتنە.', '💡 Tip: To better learn Present Simple, try to construct your daily sentences with this tense and use them in daily conversations. Consistent practice is the key to success.', 36);
