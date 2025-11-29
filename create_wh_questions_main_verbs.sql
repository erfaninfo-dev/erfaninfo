-- ایجاد مقاله جدید: Present Simple: WH Questions + Main verbs
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
    '📚 Present Simple: سوالات WH + افعال اصلی',
    '📚 Present Simple: پرسیارەکانی WH + کردارە سەرەکییەکان',
    '📚 Present Simple: WH Questions + Main verbs',
    'در این مقاله به بررسی کامل سوالات WH با افعال اصلی در زمان حال ساده می‌پردازیم. این نوع سوالات برای کسب اطلاعات خاص درباره فعالیت‌ها استفاده می‌شوند.',
    'لەم وتارەدا پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان لە کاتی ئێستای سادە بە وردەکاری بەدوادا دەکەین.',
    'In this article, we examine WH questions with main verbs in Present Simple tense comprehensively.',
    'گرامر,Present Simple,سوالات WH,افعال اصلی',
    'گرامەر,Present Simple,پرسیارەکانی WH,کردارە سەرەکییەکان',
    'grammar,present simple,wh questions,main verbs',
    'گرامر',
    30,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'سوالات WH با افعال اصلی', 'پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان', 'WH Questions with Main Verbs', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'سوالات WH با افعال اصلی پیچیده‌تر از سوالات WH با افعال to be هستند. در این نوع سوالات، از do/does به عنوان فعل کمکی استفاده می‌شود و فعل اصلی به شکل پایه (base form) می‌آید.', 'پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان ئاڵۆزترن لە پرسیارەکانی WH لەگەڵ کردارەکانی to be. لەم جۆرە پرسیارانەدا، لە do/does وەک کرداری یارمەتیدەر بەکاردەهێنرێت و کرداری سەرەکی بە شێوەی بنەڕەت (base form) دەێت.', 'WH questions with main verbs are more complex than WH questions with to be verbs. In these questions, do/does is used as an auxiliary verb and the main verb comes in base form.', 2),

-- تیتر افعال اصلی
(@article_id, 'subtitle', 'افعال اصلی در سوالات WH', 'کردارە سەرەکییەکان لە پرسیارەکانی WH', 'Main Verbs in WH Questions', 3),

-- پاراگراف افعال اصلی
(@article_id, 'paragraph', 'افعال اصلی (Main verbs) در سوالات WH به شکل پایه (base form) استفاده می‌شوند. یعنی بدون s برای فاعل‌های سوم شخص مفرد. فعل کمکی do/does برای معکوس کردن جمله استفاده می‌شود.', 'کردارە سەرەکییەکان (Main verbs) لە پرسیارەکانی WH بە شێوەی بنەڕەت (base form) بەکاردەهێنرێن. واتە بەبێ s بۆ فاعلە تاکەکانی کەسی سێیەم. کرداری یارمەتیدەری do/does بۆ پێچەوانەکردنی جملە بەکاردەهێنرێت.', 'Main verbs in WH questions are used in base form. This means without -s for third person singular subjects. The auxiliary verb do/does is used to invert the sentence.', 4),

-- تیتر ساختار کلی
(@article_id, 'subtitle', 'ساختار کلی سوالات WH با افعال اصلی', 'پێکهاتەی گشتی پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان', 'General Structure of WH Questions with Main Verbs', 5),

-- ساختار کلی
(@article_id, 'code', 'WH Word + do/does + Subject + Main Verb (base form) + Object?\nExample: Where do you work? / What does she study?', 'WH Word + do/does + Subject + Main Verb (base form) + Object?\nExample: Where do you work? / What does she study?', 'Structure: WH Word + do/does + Subject + Main Verb (base form) + Object?\nExample: Where do you work? / What does she study?', 6),

-- تیتر استفاده از do/does
(@article_id, 'subtitle', 'استفاده از do/does', 'بەکارهێنانی do/does', 'Using do/does', 7),

-- پاراگراف do/does
(@article_id, 'paragraph', 'در سوالات WH با افعال اصلی، از do برای فاعل‌های جمع (I, we, you, they) و از does برای فاعل‌های مفرد سوم شخص (he, she, it) استفاده می‌شود. فعل اصلی همیشه به شکل پایه می‌آید.', 'لە پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان، لە do بۆ فاعلە کۆکراوەکان (I, we, you, they) و لە does بۆ فاعلە تاکەکانی کەسی سێیەم (he, she, it) بەکاردەهێنرێت. کرداری سەرەکی هەمیشە بە شێوەی بنەڕەت دەێت.', 'In WH questions with main verbs, do is used for plural subjects (I, we, you, they) and does is used for third person singular subjects (he, she, it). The main verb always comes in base form.', 8),

-- تیتر Who Questions
(@article_id, 'subtitle', 'سوالات Who (چه کسی)', 'پرسیارەکانی Who (کێ)', 'Who Questions', 9),

-- پاراگراف Who
(@article_id, 'paragraph', 'سوالات Who برای پرسیدن درباره شخص یا اشخاص که عملی را انجام می‌دهند استفاده می‌شوند. این سوالات می‌توانند درباره فاعل جمله باشند.', 'پرسیارەکانی Who بۆ پرسیار دەربارەی کەس یان کەسان کە کردارێک ئەنجام دەدەن بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی فاعلی جملە بن.', 'Who questions are used to ask about a person or people who perform an action. These questions can be about the subject of the sentence.', 10),

-- ساختار Who
(@article_id, 'code', 'Who + do/does + Main Verb (base form) + Object?\nExample: Who do you know? / Who does she love?', 'Who + do/does + Main Verb (base form) + Object?\nExample: Who do you know? / Who does she love?', 'Structure: Who + do/does + Main Verb (base form) + Object?\nExample: Who do you know? / Who does she love?', 11),

-- مثال‌های Who
(@article_id, 'example', 'Who do you know? - شما چه کسی را می‌شناسید؟ (کاربرد: پرسیدن درباره آشنایان)', 'Who do you know? - تۆ کێ دەناسیت؟ (بەکارهێنان: پرسیار دەربارەی ناسراوەکان)', 'Who do you know? (Use: Asking about acquaintances)', 12),

(@article_id, 'example', 'Who does she love? - او چه کسی را دوست دارد؟ (کاربرد: پرسیدن درباره احساسات)', 'Who does she love? - ئەو کێ خۆشدەوێت؟ (بەکارهێنان: پرسیار دەربارەی هەستەکان)', 'Who does she love? (Use: Asking about feelings)', 13),

(@article_id, 'example', 'Who do they visit? - آنها چه کسی را ملاقات می‌کنند؟ (کاربرد: پرسیدن درباره ملاقات)', 'Who do they visit? - ئەوان کێ سەردان دەکەن؟ (بەکارهێنان: پرسیار دەربارەی سەردان)', 'Who do they visit? (Use: Asking about visits)', 14),

-- تیتر What Questions
(@article_id, 'subtitle', 'سوالات What (چه چیزی)', 'پرسیارەکانی What (چی)', 'What Questions', 15),

-- پاراگراف What
(@article_id, 'paragraph', 'سوالات What برای پرسیدن درباره چیز، موضوع، یا مفهومی که با فعل اصلی مرتبط است استفاده می‌شوند. این سوالات معمولاً درباره مفعول جمله هستند.', 'پرسیارەکانی What بۆ پرسیار دەربارەی شت، بابەت، یان چەمکێک کە لەگەڵ کرداری سەرەکی پەیوەندی هەیە بەکاردەهێنرێن. ئەم پرسیارانە بەگشتی دەربارەی ئەرکی جملەن.', 'What questions are used to ask about a thing, topic, or concept related to the main verb. These questions are usually about the object of the sentence.', 16),

-- ساختار What
(@article_id, 'code', 'What + do/does + Subject + Main Verb (base form)?\nExample: What do you like? / What does he study?', 'What + do/does + Subject + Main Verb (base form)?\nExample: What do you like? / What does he study?', 'Structure: What + do/does + Subject + Main Verb (base form)?\nExample: What do you like? / What does he study?', 17),

-- مثال‌های What
(@article_id, 'example', 'What do you like? - شما چه چیزی را دوست دارید؟ (کاربرد: پرسیدن درباره ترجیحات)', 'What do you like? - تۆ چی خۆشدەوێت؟ (بەکارهێنان: پرسیار دەربارەی پێشکەوتن)', 'What do you like? (Use: Asking about preferences)', 18),

(@article_id, 'example', 'What does he study? - او چه چیزی مطالعه می‌کند؟ (کاربرد: پرسیدن درباره موضوع مطالعه)', 'What does he study? - ئەو چی خوێندنەوە دەکات؟ (بەکارهێنان: پرسیار دەربارەی بابەتی خوێندنەوە)', 'What does he study? (Use: Asking about study subject)', 19),

(@article_id, 'example', 'What do they eat? - آنها چه چیزی می‌خورند؟ (کاربرد: پرسیدن درباره غذا)', 'What do they eat? - ئەوان چی دەخۆن؟ (بەکارهێنان: پرسیار دەربارەی خواردن)', 'What do they eat? (Use: Asking about food)', 20),

-- تیتر Where Questions
(@article_id, 'subtitle', 'سوالات Where (کجا)', 'پرسیارەکانی Where (لە کوێ)', 'Where Questions', 21),

-- پاراگراف Where
(@article_id, 'paragraph', 'سوالات Where برای پرسیدن درباره مکان انجام فعالیت استفاده می‌شوند. این سوالات می‌توانند درباره محل کار، زندگی، یا انجام فعالیت خاص باشند.', 'پرسیارەکانی Where بۆ پرسیار دەربارەی شوێنی ئەنجامدانی چالاکی بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی شوێنی کار، ژیان، یان ئەنجامدانی چالاکی دیاریکراو بن.', 'Where questions are used to ask about the place where an activity is performed. These questions can be about workplace, residence, or performing a specific activity.', 22),

-- ساختار Where
(@article_id, 'code', 'Where + do/does + Subject + Main Verb (base form)?\nExample: Where do you work? / Where does she live?', 'Where + do/does + Subject + Main Verb (base form)?\nExample: Where do you work? / Where does she live?', 'Structure: Where + do/does + Subject + Main Verb (base form)?\nExample: Where do you work? / Where does she live?', 23),

-- مثال‌های Where
(@article_id, 'example', 'Where do you work? - شما کجا کار می‌کنید؟ (کاربرد: پرسیدن محل کار)', 'Where do you work? - تۆ لە کوێ کار دەکەیت؟ (بەکارهێنان: پرسیار شوێنی کار)', 'Where do you work? (Use: Asking workplace)', 24),

(@article_id, 'example', 'Where does she live? - او کجا زندگی می‌کند؟ (کاربرد: پرسیدن محل زندگی)', 'Where does she live? - ئەو لە کوێ دەژیت؟ (بەکارهێنان: پرسیار شوێنی ژیان)', 'Where does she live? (Use: Asking residence)', 25),

(@article_id, 'example', 'Where do they study? - آنها کجا مطالعه می‌کنند؟ (کاربرد: پرسیدن محل مطالعه)', 'Where do they study? - ئەوان لە کوێ خوێندنەوە دەکەن؟ (بەکارهێنان: پرسیار شوێنی خوێندنەوە)', 'Where do they study? (Use: Asking study location)', 26),

-- تیتر When Questions
(@article_id, 'subtitle', 'سوالات When (چه زمانی)', 'پرسیارەکانی When (کەی)', 'When Questions', 27),

-- پاراگراف When
(@article_id, 'paragraph', 'سوالات When برای پرسیدن درباره زمان انجام فعالیت استفاده می‌شوند. این سوالات می‌توانند درباره زمان‌بندی، برنامه، یا عادت‌های روزانه باشند.', 'پرسیارەکانی When بۆ پرسیار دەربارەی کاتی ئەنجامدانی چالاکی بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی کاتی دیاریکراو، پلان، یان ڕەفتارە ڕۆژانەکان بن.', 'When questions are used to ask about the time when an activity is performed. These questions can be about scheduling, programs, or daily habits.', 28),

-- ساختار When
(@article_id, 'code', 'When + do/does + Subject + Main Verb (base form)?\nExample: When do you wake up? / When does he arrive?', 'When + do/does + Subject + Main Verb (base form)?\nExample: When do you wake up? / When does he arrive?', 'Structure: When + do/does + Subject + Main Verb (base form)?\nExample: When do you wake up? / When does he arrive?', 29),

-- مثال‌های When
(@article_id, 'example', 'When do you wake up? - شما چه زمانی بیدار می‌شوید؟ (کاربرد: پرسیدن زمان بیدار شدن)', 'When do you wake up? - تۆ کەی لە خەو هەڵدەستیت؟ (بەکارهێنان: پرسیار کاتی هەڵستن)', 'When do you wake up? (Use: Asking wake-up time)', 30),

(@article_id, 'example', 'When does he arrive? - او چه زمانی می‌رسد؟ (کاربرد: پرسیدن زمان رسیدن)', 'When does he arrive? - ئەو کەی دەگات؟ (بەکارهێنان: پرسیار کاتی گەیشتن)', 'When does he arrive? (Use: Asking arrival time)', 31),

(@article_id, 'example', 'When do they eat dinner? - آنها چه زمانی شام می‌خورند؟ (کاربرد: پرسیدن زمان شام)', 'When do they eat dinner? - ئەوان کەی شام دەخۆن؟ (بەکارهێنان: پرسیار کاتی شام)', 'When do they eat dinner? (Use: Asking dinner time)', 32),

-- تیتر Why Questions
(@article_id, 'subtitle', 'سوالات Why (چرا)', 'پرسیارەکانی Why (بۆچی)', 'Why Questions', 33),

-- پاراگراف Why
(@article_id, 'paragraph', 'سوالات Why برای پرسیدن درباره دلیل انجام فعالیت استفاده می‌شوند. این سوالات می‌توانند درباره انگیزه، هدف، یا علت انجام کاری باشند.', 'پرسیارەکانی Why بۆ پرسیار دەربارەی هۆکاری ئەنجامدانی چالاکی بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی پاڵنەر، ئامانج، یان سەبەبی ئەنجامدانی کارێک بن.', 'Why questions are used to ask about the reason for performing an activity. These questions can be about motivation, purpose, or cause of doing something.', 34),

-- ساختار Why
(@article_id, 'code', 'Why + do/does + Subject + Main Verb (base form)?\nExample: Why do you study? / Why does she work?', 'Why + do/does + Subject + Main Verb (base form)?\nExample: Why do you study? / Why does she work?', 'Structure: Why + do/does + Subject + Main Verb (base form)?\nExample: Why do you study? / Why does she work?', 35),

-- مثال‌های Why
(@article_id, 'example', 'Why do you study? - چرا شما مطالعه می‌کنید؟ (کاربرد: پرسیدن دلیل مطالعه)', 'Why do you study? - بۆچی تۆ خوێندنەوە دەکەیت؟ (بەکارهێنان: پرسیار هۆکاری خوێندنەوە)', 'Why do you study? (Use: Asking study reason)', 36),

(@article_id, 'example', 'Why does she work? - چرا او کار می‌کند؟ (کاربرد: پرسیدن دلیل کار)', 'Why does she work? - بۆچی ئەو کار دەکات؟ (بەکارهێنان: پرسیار هۆکاری کار)', 'Why does she work? (Use: Asking work reason)', 37),

(@article_id, 'example', 'Why do they travel? - چرا آنها سفر می‌کنند؟ (کاربرد: پرسیدن دلیل سفر)', 'Why do they travel? - بۆچی ئەوان گەشت دەکەن؟ (بەکارهێنان: پرسیار هۆکاری گەشت)', 'Why do they travel? (Use: Asking travel reason)', 38),

-- تیتر How Questions
(@article_id, 'subtitle', 'سوالات How (چطور)', 'پرسیارەکانی How (چۆن)', 'How Questions', 39),

-- پاراگراف How
(@article_id, 'paragraph', 'سوالات How برای پرسیدن درباره روش، کیفیت، یا میزان انجام فعالیت استفاده می‌شوند. این سوالات می‌توانند درباره نحوه انجام کار، کیفیت، یا مقدار باشند.', 'پرسیارەکانی How بۆ پرسیار دەربارەی ڕێگە، چۆنیەتی، یان بڕی ئەنجامدانی چالاکی بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی چۆنیەتی ئەنجامدانی کار، چۆنیەتی، یان بڕ بن.', 'How questions are used to ask about the method, quality, or amount of performing an activity. These questions can be about how to do something, quality, or quantity.', 40),

-- ساختار How
(@article_id, 'code', 'How + do/does + Subject + Main Verb (base form)?\nExample: How do you cook? / How does he drive?', 'How + do/does + Subject + Main Verb (base form)?\nExample: How do you cook? / How does he drive?', 'Structure: How + do/does + Subject + Main Verb (base form)?\nExample: How do you cook? / How does he drive?', 41),

-- مثال‌های How
(@article_id, 'example', 'How do you cook? - شما چطور آشپزی می‌کنید؟ (کاربرد: پرسیدن روش آشپزی)', 'How do you cook? - تۆ چۆن چێشت دەکەیت؟ (بەکارهێنان: پرسیار ڕێگەی چێشتکردن)', 'How do you cook? (Use: Asking cooking method)', 42),

(@article_id, 'example', 'How does he drive? - او چطور رانندگی می‌کند؟ (کاربرد: پرسیدن کیفیت رانندگی)', 'How does he drive? - ئەو چۆن شۆفێری دەکات؟ (بەکارهێنان: پرسیار چۆنیەتی شۆفێری)', 'How does he drive? (Use: Asking driving quality)', 43),

(@article_id, 'example', 'How do they speak English? - آنها چطور انگلیسی صحبت می‌کنند؟ (کاربرد: پرسیدن کیفیت صحبت)', 'How do they speak English? - ئەوان چۆن ئینگلیزی قسە دەکەن؟ (بەکارهێنان: پرسیار چۆنیەتی قسەکردن)', 'How do they speak English? (Use: Asking speaking quality)', 44),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 45),

-- تیتر نکات مهم
(@article_id, 'subtitle', 'نکات مهم در سوالات WH با افعال اصلی', 'خاڵە گرنگەکان لە پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان', 'Important Points in WH Questions with Main Verbs', 46),

-- نکات مهم
(@article_id, 'list', 'کلمه پرسشی همیشه در ابتدای جمله قرار می‌گیرد\nفعل کمکی do/does بعد از کلمه پرسشی می‌آید\nفاعل بعد از فعل کمکی قرار می‌گیرد\nفعل اصلی به شکل پایه (بدون s) استفاده می‌شود\nاز do برای فاعل‌های جمع و does برای فاعل‌های مفرد سوم شخص استفاده می‌شود', 'وشەی پرسیار هەمیشە لە سەرەتای جملەدا دەکەوێت\nکرداری یارمەتیدەری do/does لە دوای وشەی پرسیار دەێت\nفاعل لە دوای کرداری یارمەتیدەر دەکەوێت\nکرداری سەرەکی بە شێوەی بنەڕەت (بەبێ s) بەکاردەهێنرێت\nلە do بۆ فاعلە کۆکراوەکان و does بۆ فاعلە تاکەکانی کەسی سێیەم بەکاردەهێنرێت', 'Question word always comes at the beginning of the sentence\nAuxiliary verb do/does comes after question word\nSubject comes after auxiliary verb\nMain verb is used in base form (without -s)\nUse do for plural subjects and does for third person singular subjects', 47),

-- تیتر اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵە باوەکان', 'Common Mistakes', 48),

-- اشتباهات رایج
(@article_id, 'list', 'استفاده از s برای فعل اصلی در سوالات\nفراموش کردن فعل کمکی do/does\nقرار دادن فاعل قبل از فعل کمکی\nاستفاده نادرست از do/does\nفراموش کردن علامت سوال', 'بەکارهێنانی s بۆ کرداری سەرەکی لە پرسیارەکان\nلەبیرکردنی کرداری یارمەتیدەری do/does\nدانانی فاعل لە پێش کرداری یارمەتیدەر\nبەکارهێنانی هەڵەی do/does\nلەبیرکردنی نیشانەی پرسیار', 'Using -s for main verb in questions\nForgetting auxiliary verb do/does\nPutting subject before auxiliary verb\nIncorrect use of do/does\nForgetting question mark', 49),

-- مثال‌های اشتباهات
(@article_id, 'example', '❌ Where you work? → ✅ Where do you work?\n❌ What does she studies? → ✅ What does she study?\n❌ Who do he know? → ✅ Who does he know?', '❌ Where you work? → ✅ Where do you work?\n❌ What does she studies? → ✅ What does she study?\n❌ Who do he know? → ✅ Who does he know?', '❌ Where you work? → ✅ Where do you work?\n❌ What does she studies? → ✅ What does she study?\n❌ Who do he know? → ✅ Who does he know?', 50),

-- تیتر نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی', 'خاڵە بەکارهێنراوەکان', 'Practical Tips', 51),

-- نکات کاربردی
(@article_id, 'list', 'همیشه با کلمه پرسشی شروع کنید\nفعل کمکی do/does را اضافه کنید\nفعل اصلی را به شکل پایه استفاده کنید\nبه ترتیب کلمات دقت کنید\nتمرین مداوم با مثال‌های مختلف داشته باشید', 'هەمیشە بە وشەی پرسیار دەست پێبکە\nکرداری یارمەتیدەری do/does زیاد بکە\nکرداری سەرەکی بە شێوەی بنەڕەت بەکاربێنە\nسەرنج بدە بە ڕیزکردنی وشەکان\nڕاهێنانی بەردەوام لەگەڵ نموونەی جیاواز هەبێت', 'Always start with question word\nAdd auxiliary verb do/does\nUse main verb in base form\nPay attention to word order\nPractice regularly with different examples', 52),

-- نقل قول
(@article_id, 'quote', 'سوالات WH با افعال اصلی ابزار قدرتمندی برای کسب اطلاعات دقیق درباره فعالیت‌ها و رفتارها هستند. تسلط بر این ساختار به شما کمک می‌کند تا ارتباط مؤثرتری داشته باشید.', 'پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان ئامرازێکی بەهێزن بۆ بەدەستهێنانی زانیاری ورد دەربارەی چالاکی و ڕەفتارەکانن. لێهاتوویی لەم پێکهاتەیە یارمەتیت دەدات تا پەیوەندی کاریگەرتر هەبێت.', 'WH questions with main verbs are powerful tools for getting accurate information about activities and behaviors. Mastering this structure helps you have more effective communication.', 53),

-- نکته مهم
(@article_id, 'note', 'برای یادگیری بهتر سوالات WH با افعال اصلی، سعی کنید در مکالمات روزانه از این سوالات استفاده کنید. تمرین مداوم و استفاده از مثال‌های واقعی به شما کمک می‌کند تا این ساختار پیچیده را بهتر درک کنید.', 'بۆ فێربوونی باشتری پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان، هەوڵ بدە لە گفتوگۆی ڕۆژانەدا لەم پرسیارانە بەکاربێنیت. ڕاهێنانی بەردەوام و بەکارهێنانی نموونەی ڕاستەقینە یارمەتیت دەدات تا ئەم پێکهاتەی ئاڵۆزە باشتر لێکبەیتەوە.', 'To better learn WH questions with main verbs, try to use these questions in daily conversations. Regular practice and using real examples will help you better understand this complex structure.', 54),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای تشخیص سوالات WH با افعال اصلی، به وجود فعل کمکی do/does و شکل پایه فعل اصلی توجه کنید. اگر جمله با کلمه پرسشی شروع شود و فعل کمکی داشته باشد، احتمالاً سوال WH با فعل اصلی است.', '💡 خاڵ: بۆ ناسینەوەی پرسیارەکانی WH لەگەڵ کردارە سەرەکییەکان، سەرنج بدە بە بوونی کرداری یارمەتیدەری do/does و شێوەی بنەڕەتی کرداری سەرەکی. ئەگەر جملە بە وشەی پرسیار دەست پێبکات و کرداری یارمەتیدەری هەبێت، لەوانەیە پرسیاری WH لەگەڵ کرداری سەرەکی بێت.', '💡 Tip: To identify WH questions with main verbs, pay attention to the presence of auxiliary verb do/does and base form of main verb. If the sentence starts with a question word and has an auxiliary verb, it is likely a WH question with main verb.', 55);
