-- مقاله نمونه: گرامر Present Perfect
-- ابتدا مقاله اصلی را ایجاد می‌کنیم
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
    '⚙️ نکات مهم گرامر Present Perfect',
    '⚙️ گرنگترین خاڵەکانی گرامەری Present Perfect',
    '⚙️ Important Points of Present Perfect Grammar',
    'در این مقاله به بررسی نکات مهم و کاربردی گرامر Present Perfect می‌پردازیم. این زمان یکی از پرکاربردترین زمان‌های انگلیسی است.',
    'لەم وتارەدا گرنگترین خاڵەکانی گرامەری Present Perfect بەکارهێنراو بەدوادا دەکەین.',
    'In this article, we examine the important and practical points of Present Perfect grammar.',
    'گرامر,Present Perfect,زمان انگلیسی',
    'گرامەر,Present Perfect,زمانی ئینگلیزی',
    'grammar,present perfect,english tenses',
    'گرامر',
    12,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'کاربردهای Present Perfect', 'بەکارهێنانەکانی Present Perfect', 'Uses of Present Perfect', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'Present Perfect یکی از مهم‌ترین زمان‌های انگلیسی است که برای بیان عملی استفاده می‌شود که در گذشته شروع شده و تا حال ادامه دارد یا نتیجه آن در حال حاضر مهم است.', 'Present Perfect یەکێکە لە گرنگترین کاتەکانی زمانی ئینگلیزی کە بۆ باسکردنی کردارێک بەکاردەهێنرێت کە لە ڕابردوودا دەستی پێکردووە و تا ئێستا بەردەوامە.', 'Present Perfect is one of the most important English tenses used to express an action that started in the past and continues to the present or whose result is important now.', 2),

-- لیست کاربردها
(@article_id, 'list', 'عملی که در گذشته شروع شده و تا حال ادامه دارد\nتجربیات زندگی\nعملی که در گذشته انجام شده اما نتیجه آن در حال حاضر مهم است\nعملی که در گذشته نزدیک انجام شده', 'کردارێک کە لە ڕابردوودا دەستی پێکردووە و تا ئێستا بەردەوامە\nئەزموونەکانی ژیان\nکردارێک کە لە ڕابردوودا ئەنجام دراوە بەڵام ئەنجامی ئێستا گرنگە\nکردارێک کە لە ڕابردووی نزیکدا ئەنجام دراوە', 'An action that started in the past and continues to the present\nLife experiences\nAn action that was completed in the past but its result is important now\nAn action that was completed in the recent past', 3),

-- تیتر ساختار
(@article_id, 'subtitle', 'ساختار Present Perfect', 'پێکهاتەی Present Perfect', 'Structure of Present Perfect', 4),

-- کد ساختار
(@article_id, 'code', 'Subject + have/has + Past Participle', 'Subject + have/has + Past Participle', 'Subject + have/has + Past Participle', 5),

-- نکته مهم
(@article_id, 'note', 'از "have" برای فاعل‌های جمع (I, we, you, they) و از "has" برای فاعل‌های مفرد (he, she, it) استفاده می‌شود.', 'لە "have" بۆ فاعلە کۆکراوەکان (I, we, you, they) و لە "has" بۆ فاعلە تاکەکان (he, she, it) بەکاردەهێنرێت.', 'Use "have" for plural subjects (I, we, you, they) and "has" for singular subjects (he, she, it).', 6),

-- تیتر مثال‌ها
(@article_id, 'subtitle', 'مثال‌های کاربردی', 'بەکارهێنراوەکانی نموونە', 'Practical Examples', 7),

-- مثال اول
(@article_id, 'example', 'I have lived in Tehran for 5 years. - من 5 سال است که در تهران زندگی می‌کنم.', 'I have lived in Tehran for 5 years. - من 5 ساڵە لە تەهران دەژیم.', 'I have lived in Tehran for 5 years. - I have been living in Tehran for 5 years.', 8),

-- مثال دوم
(@article_id, 'example', 'She has never been to Paris. - او هرگز به پاریس نرفته است.', 'She has never been to Paris. - ئەو هەرگیز نەچووەتە پاریس.', 'She has never been to Paris. - She has never visited Paris.', 9),

-- مثال سوم
(@article_id, 'example', 'We have just finished our homework. - ما تازه تکالیفمان را تمام کرده‌ایم.', 'We have just finished our homework. - ئێمە تازە تەسکەکانمان تەواومان کردووە.', 'We have just finished our homework. - We have just completed our homework.', 10),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 11),

-- نکات مهم
(@article_id, 'note', 'از "for" برای مدت زمان استفاده کنید: I have worked here for 3 years. از "since" برای نقطه شروع استفاده کنید: I have worked here since 2020. از "just" برای عملی که تازه انجام شده استفاده کنید: I have just arrived. از "never" و "ever" برای تجربیات استفاده کنید: Have you ever been to London?', 'لە "for" بۆ ماوەی کات بەکاربێنە: I have worked here for 3 years. لە "since" بۆ خاڵی دەستپێک بەکاربێنە: I have worked here since 2020. لە "just" بۆ کردارێک کە تازە ئەنجام دراوە بەکاربێنە: I have just arrived. لە "never" و "ever" بۆ ئەزموونەکان بەکاربێنە: Have you ever been to London?', 'Use "for" for duration: I have worked here for 3 years. Use "since" for starting point: I have worked here since 2020. Use "just" for recently completed action: I have just arrived. Use "never" and "ever" for experiences: Have you ever been to London?', 12),

-- تیتر تمرین
(@article_id, 'subtitle', 'تمرین', 'ڕاهێنان', 'Exercise', 13),

-- تمرین
(@article_id, 'exercise', 'جملات زیر را با استفاده از Present Perfect کامل کنید:\n\n1. I _____ (live) in this city for 10 years.\n2. She _____ (never/visit) Paris before.\n3. We _____ (just/finish) our project.\n4. _____ you ever _____ (be) to London?\n5. They _____ (work) here since 2018.\n\nپاسخ‌ها:\n1. have lived\n2. has never visited\n3. have just finished\n4. Have, been\n5. have worked', 'جملات زیر را با استفاده از Present Perfect کامل کنید:\n\n1. I _____ (live) in this city for 10 years.\n2. She _____ (never/visit) Paris before.\n3. We _____ (just/finish) our project.\n4. _____ you ever _____ (be) to London?\n5. They _____ (work) here since 2018.\n\nپاسخ‌ها:\n1. have lived\n2. has never visited\n3. have just finished\n4. Have, been\n5. have worked', 'Complete the following sentences using Present Perfect:\n\n1. I _____ (live) in this city for 10 years.\n2. She _____ (never/visit) Paris before.\n3. We _____ (just/finish) our project.\n4. _____ you ever _____ (be) to London?\n5. They _____ (work) here since 2018.\n\nAnswers:\n1. have lived\n2. has never visited\n3. have just finished\n4. Have, been\n5. have worked', 14),

-- نقل قول
(@article_id, 'quote', 'Present Perfect پلی است بین گذشته و حال که به ما کمک می‌کند تا ارتباط بین زمان‌ها را بهتر درک کنیم.', 'Present Perfect پردێکە لە نێوان ڕابردوو و ئێستا کە یارمەتیمان دەدات تا پەیوەندی نێوان کاتەکان باشتر لێکبەینەوە.', 'Present Perfect is a bridge between past and present that helps us better understand the connection between tenses.', 15),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای یادگیری بهتر Present Perfect، سعی کنید جملات روزمره خود را با این زمان بسازید و در مکالمات روزانه استفاده کنید.', '💡 خاڵ: بۆ فێربوونی باشتری Present Perfect، هەوڵ بدە جملات ڕۆژانەکانت بەم کاتە دروست بکەیت و لە گفتوگۆی ڕۆژانەدا بەکاربێنیت.', '💡 Tip: To better learn Present Perfect, try to construct your daily sentences with this tense and use them in daily conversations.', 16);
