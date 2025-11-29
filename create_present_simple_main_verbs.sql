-- ایجاد مقاله جدید: Present Simple: Main verbs
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
    '📚 Present Simple: افعال اصلی',
    '📚 Present Simple: کردارە سەرەکییەکان',
    '📚 Present Simple: Main verbs',
    'در این مقاله به بررسی کامل افعال اصلی در زمان حال ساده می‌پردازیم. این زمان یکی از مهم‌ترین زمان‌های انگلیسی است.',
    'لەم وتارەدا کردارە سەرەکییەکان لە کاتی ئێستای سادە بە وردەکاری بەدوادا دەکەین.',
    'In this article, we examine main verbs in Present Simple tense comprehensively.',
    'گرامر,Present Simple,افعال اصلی',
    'گرامەر,Present Simple,کردارە سەرەکییەکان',
    'grammar,present simple,main verbs',
    'گرامر',
    20,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'کاربردهای Present Simple', 'بەکارهێنانەکانی Present Simple', 'Uses of Present Simple', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'Present Simple یکی از مهم‌ترین زمان‌های انگلیسی است که برای بیان عملی استفاده می‌شود که در گذشته شروع شده و تا حال ادامه دارد یا نتیجه آن در حال حاضر مهم است.', 'Present Simple یەکێکە لە گرنگترین کاتەکانی زمانی ئینگلیزی کە بۆ باسکردنی کردارێک بەکاردەهێنرێت کە لە ڕابردوودا دەستی پێکردووە و تا ئێستا بەردەوامە.', 'Present Simple is one of the most important English tenses used to express actions that are habitual, factual, or general truths.', 2),

-- لیست کاربردها
(@article_id, 'list', 'عملی که در گذشته شروع شده و تا حال ادامه دارد\nتجربیات زندگی\nعملی که در گذشته انجام شده اما نتیجه آن در حال حاضر مهم است\nعملی که در گذشته نزدیک انجام شده\nحقایق علمی و عمومی\nبرنامه‌های آینده (زمان‌بندی شده)', 'کردارێک کە لە ڕابردوودا دەستی پێکردووە و تا ئێستا بەردەوامە\nئەزموونەکانی ژیان\nکردارێک کە لە ڕابردوودا ئەنجام دراوە بەڵام ئەنجامی ئێستا گرنگە\nکردارێک کە لە ڕابردووی نزیکدا ئەنجام دراوە\nڕاستییە زانستی و گشتییەکان\nپلانەکانی داهاتوو (کاتی دیاریکراو)', 'An action that started in the past and continues to the present\nLife experiences\nAn action that was completed in the past but its result is important now\nAn action that was completed in the recent past\nScientific and general facts\nFuture schedules (timetabled events)', 3),

-- تیتر افعال اصلی
(@article_id, 'subtitle', 'افعال اصلی و کاربرد آن در زمان حال ساده', 'کردارە سەرەکییەکان و بەکارهێنانیان لە کاتی ئێستای سادە', 'Main verbs and their use in Present Simple', 4),

-- پاراگراف افعال اصلی
(@article_id, 'paragraph', 'افعال اصلی (Main verbs) افعالی هستند که معنی کامل دارند و می‌توانند به تنهایی در جمله استفاده شوند. در زمان حال ساده، این افعال با فاعل‌های مختلف تغییر می‌کنند.', 'کردارە سەرەکییەکان (Main verbs) ئەو کردارانەن کە مانای تەواویان هەیە و دەتوانن بە تەنها لە جملەدا بەکاربێن. لە کاتی ئێستای سادە، ئەم کردارانە لەگەڵ فاعلە جیاوازەکان دەگونجێن.', 'Main verbs are verbs that have complete meaning and can be used independently in sentences. In Present Simple, these verbs change with different subjects.', 5),

-- تیتر نوع جمله
(@article_id, 'subtitle', 'نوع جمله', 'جۆری جملە', 'Sentence Types', 6),

-- پاراگراف نوع جمله
(@article_id, 'paragraph', 'در زمان حال ساده، سه نوع جمله اصلی داریم: جملات مثبت، جملات منفی، و جملات سوالی. هر کدام ساختار خاص خود را دارند.', 'لە کاتی ئێستای سادە، سێ جۆری جملەی سەرەکیمان هەیە: جملە بەڵێنەکان، جملە نەڕێنەکان، و جملە پرسیارەکان. هەر یەک پێکهاتەی تایبەتی خۆی هەیە.', 'In Present Simple, we have three main sentence types: affirmative sentences, negative sentences, and interrogative sentences. Each has its own specific structure.', 7),

-- تیتر جملات مثبت
(@article_id, 'subtitle', 'جملات مثبت (Affirmative)', 'جملە بەڵێنەکان (Affirmative)', 'Affirmative Sentences', 8),

-- پاراگراف جملات مثبت
(@article_id, 'paragraph', 'جملات مثبت جملاتی هستند که عملی را تأیید می‌کنند. در زمان حال ساده، فعل اصلی با فاعل‌های مفرد سوم شخص (he, she, it) به s ختم می‌شود.', 'جملە بەڵێنەکان ئەو جملانەن کە کردارێک پشتڕاست دەکەنەوە. لە کاتی ئێستای سادە، کرداری سەرەکی لەگەڵ فاعلە تاکەکانی کەسی سێیەم (he, she, it) بە s کۆتایی دەهێنێت.', 'Affirmative sentences confirm an action. In Present Simple, the main verb ends with -s for third person singular subjects (he, she, it).', 9),

-- ساختار جملات مثبت
(@article_id, 'code', 'Subject + Main Verb (+s for 3rd person singular)\nExample: I work. / He works.', 'Subject + Main Verb (+s for 3rd person singular)\nExample: I work. / He works.', 'Structure: Subject + Main Verb (+s for 3rd person singular)\nExample: I work. / He works.', 10),

-- مثال‌های جملات مثبت
(@article_id, 'example', 'I work in Tehran. - من در تهران کار می‌کنم. (کاربرد: حرفه)', 'I work in Tehran. - من لە تەهران کار دەکەم. (بەکارهێنان: پیشە)', 'I work in Tehran. (Use: Profession)', 11),

(@article_id, 'example', 'She studies English. - او انگلیسی مطالعه می‌کند. (کاربرد: فعالیت روزانه)', 'She studies English. - ئەو ئینگلیزی خوێندنەوە دەکات. (بەکارهێنان: چالاکی ڕۆژانە)', 'She studies English. (Use: Daily activity)', 12),

(@article_id, 'example', 'They live in London. - آنها در لندن زندگی می‌کنند. (کاربرد: موقعیت)', 'They live in London. - ئەوان لە لەندەن دەژین. (بەکارهێنان: شوێن)', 'They live in London. (Use: Location)', 13),

-- تیتر جملات منفی
(@article_id, 'subtitle', 'جملات منفی (Negative)', 'جملە نەڕێنەکان (Negative)', 'Negative Sentences', 14),

-- پاراگراف جملات منفی
(@article_id, 'paragraph', 'جملات منفی جملاتی هستند که عملی را نفی می‌کنند. در زمان حال ساده، از do/does + not + فعل اصلی استفاده می‌شود. از "do" برای فاعل‌های جمع (I, we, you, they) و از "does" برای فاعل‌های مفرد سوم شخص (he, she, it) استفاده می‌شود.', 'جملە نەڕێنەکان ئەو جملانەن کە کردارێک ڕەت دەکەنەوە. لە کاتی ئێستای سادە، لە do/does + not + کرداری سەرەکی بەکاردەهێنرێت. لە "do" بۆ فاعلە کۆکراوەکان (I, we, you, they) و لە "does" بۆ فاعلە تاکەکانی کەسی سێیەم (he, she, it) بەکاردەهێنرێت.', 'Negative sentences deny an action. In Present Simple, we use do/does + not + main verb. Use "do" for plural subjects (I, we, you, they) and "does" for third person singular subjects (he, she, it).', 15),

-- ساختار جملات منفی
(@article_id, 'code', 'Subject + do/does + not + Main Verb (base form)\nExample: I do not work. / He does not work.', 'Subject + do/does + not + Main Verb (base form)\nExample: I do not work. / He does not work.', 'Structure: Subject + do/does + not + Main Verb (base form)\nExample: I do not work. / He does not work.', 16),

-- مثال‌های جملات منفی
(@article_id, 'example', 'I do not like coffee. - من قهوه دوست ندارم. (کاربرد: ترجیحات)', 'I do not like coffee. - من قاوە خۆشم نایەت. (بەکارهێنان: پێشکەوتن)', 'I do not like coffee. (Use: Preferences)', 17),

(@article_id, 'example', 'She does not speak French. - او فرانسوی صحبت نمی‌کند. (کاربرد: مهارت)', 'She does not speak French. - ئەو فەرەنسی قسە ناکات. (بەکارهێنان: لێهاتوویی)', 'She does not speak French. (Use: Skill)', 18),

(@article_id, 'example', 'They do not play football. - آنها فوتبال بازی نمی‌کنند. (کاربرد: فعالیت)', 'They do not play football. - ئەوان تۆپی پێ یاری ناکەن. (بەکارهێنان: چالاکی)', 'They do not play football. (Use: Activity)', 19),

-- تیتر جملات سوالی
(@article_id, 'subtitle', 'جملات سوالی (Interrogative)', 'جملە پرسیارەکان (Interrogative)', 'Interrogative Sentences', 20),

-- پاراگراف جملات سوالی
(@article_id, 'paragraph', 'جملات سوالی جملاتی هستند که سوال می‌پرسند. در زمان حال ساده، از do/does + فاعل + فعل اصلی استفاده می‌شود. از "do" برای فاعل‌های جمع (I, we, you, they) و از "does" برای فاعل‌های مفرد سوم شخص (he, she, it) استفاده می‌شود.', 'جملە پرسیارەکان ئەو جملانەن کە پرسیار دەکەن. لە کاتی ئێستای سادە، لە do/does + فاعل + کرداری سەرەکی بەکاردەهێنرێت. لە "do" بۆ فاعلە کۆکراوەکان (I, we, you, they) و لە "does" بۆ فاعلە تاکەکانی کەسی سێیەم (he, she, it) بەکاردەهێنرێت.', 'Interrogative sentences ask questions. In Present Simple, we use do/does + subject + main verb. Use "do" for plural subjects (I, we, you, they) and "does" for third person singular subjects (he, she, it).', 21),

-- ساختار جملات سوالی
(@article_id, 'code', 'Do/Does + Subject + Main Verb (base form)?\nExample: Do you work? / Does he work?', 'Do/Does + Subject + Main Verb (base form)?\nExample: Do you work? / Does he work?', 'Structure: Do/Does + Subject + Main Verb (base form)?\nExample: Do you work? / Does he work?', 22),

-- مثال‌های جملات سوالی
(@article_id, 'example', 'Do you study English? - آیا شما انگلیسی مطالعه می‌کنید؟ (کاربرد: سوال درباره فعالیت)', 'Do you study English? - ئایا تۆ ئینگلیزی خوێندنەوە دەکەیت؟ (بەکارهێنان: پرسیار دەربارەی چالاکی)', 'Do you study English? (Use: Question about activity)', 23),

(@article_id, 'example', 'Does she live here? - آیا او اینجا زندگی می‌کند؟ (کاربرد: سوال درباره موقعیت)', 'Does she live here? - ئایا ئەو لێرە دەژیت؟ (بەکارهێنان: پرسیار دەربارەی شوێن)', 'Does she live here? (Use: Question about location)', 24),

(@article_id, 'example', 'Do they work here? - آیا آنها اینجا کار می‌کنند؟ (کاربرد: سوال درباره حرفه)', 'Do they work here? - ئایا ئەوان لێرە کار دەکەن؟ (بەکارهێنان: پرسیار دەربارەی پیشە)', 'Do they work here? (Use: Question about profession)', 25),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 26),

-- تیتر کلمات نشانه
(@article_id, 'subtitle', 'کلمات نشانه', 'وشە نیشاندەرەکان', 'Signal Words', 27),

-- کلمات نشانه
(@article_id, 'list', 'always - همیشه\nusually - معمولاً\noften - اغلب\nsometimes - گاهی اوقات\nrarely - به ندرت\nnever - هرگز\nevery day - هر روز\non Mondays - دوشنبه‌ها', 'always - هەمیشە\nusually - بەگشتی\noften - زۆر جار\nsometimes - هەندێک جار\nrarely - بە دەگمە\nnever - هەرگیز\nevery day - هەر ڕۆژێک\non Mondays - دووشەممەکان', 'always\nusually\noften\nsometimes\nrarely\nnever\nevery day\non Mondays', 28),

-- مثال‌های کلمات نشانه
(@article_id, 'list', 'always - I always work hard. - من همیشه سخت کار می‌کنم.\nusually - She usually studies at night. - او معمولاً شب‌ها مطالعه می‌کند.\noften - They often visit their parents. - آنها اغلب والدینشان را ملاقات می‌کنند.\nsometimes - He sometimes plays tennis. - او گاهی اوقات تنیس بازی می‌کند.\nrarely - We rarely go to the cinema. - ما به ندرت به سینما می‌رویم.\nnever - I never smoke. - من هرگز سیگار نمی‌کشم.', 'always - I always work hard. - من هەمیشە بە زەحمەت کار دەکەم.\nusually - She usually studies at night. - ئەو بەگشتی شەوان خوێندنەوە دەکات.\noften - They often visit their parents. - ئەوان زۆر جار دایک و باوکیان سەردان دەکەن.\nsometimes - He sometimes plays tennis. - ئەو هەندێک جار تێنیس یاری دەکات.\nrarely - We rarely go to the cinema. - ئێمە بە دەگمە دەچین بۆ سینەما.\nnever - I never smoke. - من هەرگیز جگەرە ناکەم.', 'always - I always work hard.\nusually - She usually studies at night.\noften - They often visit their parents.\nsometimes - He sometimes plays tennis.\nrarely - We rarely go to the cinema.\nnever - I never smoke.', 29),

-- تیتر اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵە باوەکان', 'Common Mistakes', 30),

-- اشتباهات رایج
(@article_id, 'list', 'فراموش کردن s برای فاعل‌های سوم شخص مفرد\nاستفاده نادرست از do/does در جملات مثبت\nفراموش کردن not در جملات منفی\nاستفاده نادرست از کلمات نشانه\nفراموش کردن ساختار سوالی', 'لەبیرکردنی s بۆ فاعلە تاکەکانی کەسی سێیەم\nبەکارهێنانی هەڵەی do/does لە جملە بەڵێنەکان\nلەبیرکردنی not لە جملە نەڕێنەکان\nبەکارهێنانی هەڵەی وشە نیشاندەرەکان\nلەبیرکردنی پێکهاتەی پرسیار', 'Forgetting -s for third person singular subjects\nIncorrect use of do/does in affirmative sentences\nForgetting not in negative sentences\nIncorrect use of signal words\nForgetting interrogative structure', 31),

-- مثال‌های اشتباهات
(@article_id, 'example', '❌ He work here. → ✅ He works here.\n❌ I does not like it. → ✅ I do not like it.\n❌ Do you works here? → ✅ Do you work here?', '❌ He work here. → ✅ He works here.\n❌ I does not like it. → ✅ I do not like it.\n❌ Do you works here? → ✅ Do you work here?', '❌ He work here. → ✅ He works here.\n❌ I does not like it. → ✅ I do not like it.\n❌ Do you works here? → ✅ Do you work here?', 32),

-- تیتر نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی', 'خاڵە بەکارهێنراوەکان', 'Practical Tips', 33),

-- نکات کاربردی
(@article_id, 'list', 'همیشه به فاعل توجه کنید تا s را درست اضافه کنید\nاز کلمات نشانه برای تشخیص زمان استفاده کنید\nتمرین مداوم با جملات مختلف داشته باشید\nبه ساختار جملات منفی و سوالی دقت کنید\nاز مثال‌های واقعی استفاده کنید', 'هەمیشە سەرنج بدە بە فاعل تا s بە دروستی زیاد بکەیت\nلە وشە نیشاندەرەکان بۆ ناسینەوەی کات بەکاربێنە\nڕاهێنانی بەردەوام لەگەڵ جملە جیاوازەکان هەبێت\nسەرنج بدە بە پێکهاتەی جملە نەڕێنەکان و پرسیارەکان\nلە نموونەی ڕاستەقینە بەکاربێنە', 'Always pay attention to the subject to add -s correctly\nUse signal words to identify the tense\nPractice regularly with different sentences\nPay attention to negative and interrogative structures\nUse real examples', 34),

-- نقل قول
(@article_id, 'quote', 'Present Simple پایه و اساس زبان انگلیسی است. تسلط بر این زمان کلید موفقیت در یادگیری زبان است.', 'Present Simple بنەڕەت و پێکهاتەی زمانی ئینگلیزییە. لێهاتوویی لەم کاتە کلیلی سەرکەوتنە لە فێربوونی زمان.', 'Present Simple is the foundation of English language. Mastering this tense is the key to success in language learning.', 35),

-- نکته مهم
(@article_id, 'note', 'برای یادگیری بهتر Present Simple، سعی کنید جملات روزمره خود را با این زمان بسازید و در مکالمات روزانه استفاده کنید. تمرین مداوم و استفاده از مثال‌های واقعی به شما کمک می‌کند تا این زمان را بهتر درک کنید.', 'بۆ فێربوونی باشتری Present Simple، هەوڵ بدە جملات ڕۆژانەکانت بەم کاتە دروست بکەیت و لە گفتوگۆی ڕۆژانەدا بەکاربێنیت. ڕاهێنانی بەردەوام و بەکارهێنانی نموونەی ڕاستەقینە یارمەتیت دەدات تا ئەم کاتە باشتر لێکبەیتەوە.', 'To better learn Present Simple, try to construct your daily sentences with this tense and use them in daily conversations. Regular practice and using real examples will help you better understand this tense.', 36),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای تشخیص زمان حال ساده، به کلمات نشانه و ساختار جمله توجه کنید. اگر فعل اصلی با فاعل‌های سوم شخص مفرد s داشته باشد، احتمالاً زمان حال ساده است.', '💡 خاڵ: بۆ ناسینەوەی کاتی ئێستای سادە، سەرنج بدە بە وشە نیشاندەرەکان و پێکهاتەی جملە. ئەگەر کرداری سەرەکی لەگەڵ فاعلە تاکەکانی کەسی سێیەم s هەبێت، لەوانەیە کاتی ئێستای سادە بێت.', '💡 Tip: To identify Present Simple, pay attention to signal words and sentence structure. If the main verb has -s with third person singular subjects, it is likely Present Simple.', 37);
