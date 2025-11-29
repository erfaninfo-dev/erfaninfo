-- ایجاد مقاله جدید: Present Simple: WH Questions + to be verbs
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
    '📚 Present Simple: سوالات WH + افعال to be',
    '📚 Present Simple: پرسیارەکانی WH + کردارەکانی to be',
    '📚 Present Simple: WH Questions + to be verbs',
    'در این مقاله به بررسی کامل سوالات WH با افعال to be در زمان حال ساده می‌پردازیم. این نوع سوالات برای کسب اطلاعات خاص استفاده می‌شوند.',
    'لەم وتارەدا پرسیارەکانی WH لەگەڵ کردارەکانی to be لە کاتی ئێستای سادە بە وردەکاری بەدوادا دەکەین.',
    'In this article, we examine WH questions with to be verbs in Present Simple tense comprehensively.',
    'گرامر,Present Simple,سوالات WH,to be',
    'گرامەر,Present Simple,پرسیارەکانی WH,to be',
    'grammar,present simple,wh questions,to be',
    'گرامر',
    25,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'سوالات WH چیست؟', 'پرسیارەکانی WH چییە؟', 'What are WH Questions?', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'سوالات WH سوالاتی هستند که با کلمات پرسشی شروع می‌شوند و برای کسب اطلاعات خاص استفاده می‌شوند. این سوالات با کلمات Who, What, Where, When, Why, How شروع می‌شوند.', 'پرسیارەکانی WH ئەو پرسیارانەن کە بە وشەی پرسیار دەست پێدەکەن و بۆ بەدەستهێنانی زانیاری دیاریکراو بەکاردەهێنرێن. ئەم پرسیارانە بە وشەکانی Who, What, Where, When, Why, How دەست پێدەکەن.', 'WH questions are questions that start with question words and are used to get specific information. These questions begin with Who, What, Where, When, Why, How.', 2),

-- تیتر افعال to be
(@article_id, 'subtitle', 'افعال to be در سوالات WH', 'کردارەکانی to be لە پرسیارەکانی WH', 'to be verbs in WH Questions', 3),

-- پاراگراف افعال to be
(@article_id, 'paragraph', 'افعال to be (am, is, are) در سوالات WH به صورت معکوس استفاده می‌شوند. یعنی فعل to be قبل از فاعل قرار می‌گیرد و کلمه پرسشی در ابتدای جمله می‌آید.', 'کردارەکانی to be (am, is, are) لە پرسیارەکانی WH بە شێوەی پێچەوانە بەکاردەهێنرێن. واتە کرداری to be لە پێش فاعل دەکەوێت و وشەی پرسیار لە سەرەتای جملەدا دەێت.', 'to be verbs (am, is, are) are used in inverted form in WH questions. The to be verb comes before the subject and the question word comes at the beginning of the sentence.', 4),

-- تیتر ساختار کلی
(@article_id, 'subtitle', 'ساختار کلی سوالات WH با to be', 'پێکهاتەی گشتی پرسیارەکانی WH لەگەڵ to be', 'General Structure of WH Questions with to be', 5),

-- ساختار کلی
(@article_id, 'code', 'WH Word + to be + Subject + Complement?\nExample: Where are you? / What is your name?', 'WH Word + to be + Subject + Complement?\nExample: Where are you? / What is your name?', 'Structure: WH Word + to be + Subject + Complement?\nExample: Where are you? / What is your name?', 6),

-- تیتر انواع WH Words
(@article_id, 'subtitle', 'انواع کلمات پرسشی WH', 'جۆرەکانی وشەی پرسیاری WH', 'Types of WH Question Words', 7),

-- لیست کلمات پرسشی
(@article_id, 'list', 'Who - چه کسی (برای پرسیدن درباره شخص)\nWhat - چه چیزی (برای پرسیدن درباره چیز یا موضوع)\nWhere - کجا (برای پرسیدن درباره مکان)\nWhen - چه زمانی (برای پرسیدن درباره زمان)\nWhy - چرا (برای پرسیدن درباره دلیل)\nHow - چطور (برای پرسیدن درباره روش یا حالت)', 'Who - کێ (بۆ پرسیار دەربارەی کەس)\nWhat - چی (بۆ پرسیار دەربارەی شت یان بابەت)\nWhere - لە کوێ (بۆ پرسیار دەربارەی شوێن)\nWhen - کەی (بۆ پرسیار دەربارەی کات)\nWhy - بۆچی (بۆ پرسیار دەربارەی هۆکار)\nHow - چۆن (بۆ پرسیار دەربارەی ڕێگە یان دۆخ)', 'Who - for asking about person\nWhat - for asking about thing or topic\nWhere - for asking about place\nWhen - for asking about time\nWhy - for asking about reason\nHow - for asking about method or condition', 8),

-- تیتر Who Questions
(@article_id, 'subtitle', 'سوالات Who (چه کسی)', 'پرسیارەکانی Who (کێ)', 'Who Questions', 9),

-- پاراگراف Who
(@article_id, 'paragraph', 'سوالات Who برای پرسیدن درباره شخص یا اشخاص استفاده می‌شوند. این سوالات می‌توانند درباره هویت، حرفه، یا رابطه شخصی باشند.', 'پرسیارەکانی Who بۆ پرسیار دەربارەی کەس یان کەسان بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی ناسنامە، پیشە، یان پەیوەندی کەسی بن.', 'Who questions are used to ask about a person or people. These questions can be about identity, profession, or personal relationship.', 10),

-- ساختار Who
(@article_id, 'code', 'Who + to be + Subject/Complement?\nExample: Who are you? / Who is she?', 'Who + to be + Subject/Complement?\nExample: Who are you? / Who is she?', 'Structure: Who + to be + Subject/Complement?\nExample: Who are you? / Who is she?', 11),

-- مثال‌های Who
(@article_id, 'example', 'Who are you? - شما چه کسی هستید؟ (کاربرد: پرسیدن هویت)', 'Who are you? - تۆ کێیت؟ (بەکارهێنان: پرسیار دەربارەی ناسنامە)', 'Who are you? (Use: Asking identity)', 12),

(@article_id, 'example', 'Who is your teacher? - معلم شما چه کسی است؟ (کاربرد: پرسیدن حرفه)', 'Who is your teacher? - مامۆستات کێیە؟ (بەکارهێنان: پرسیار دەربارەی پیشە)', 'Who is your teacher? (Use: Asking profession)', 13),

(@article_id, 'example', 'Who are they? - آنها چه کسانی هستند؟ (کاربرد: پرسیدن درباره گروه)', 'Who are they? - ئەوان کێن؟ (بەکارهێنان: پرسیار دەربارەی کۆمەڵ)', 'Who are they? (Use: Asking about group)', 14),

-- تیتر What Questions
(@article_id, 'subtitle', 'سوالات What (چه چیزی)', 'پرسیارەکانی What (چی)', 'What Questions', 15),

-- پاراگراف What
(@article_id, 'paragraph', 'سوالات What برای پرسیدن درباره چیز، موضوع، یا مفهوم استفاده می‌شوند. این سوالات می‌توانند درباره نام، نوع، یا ماهیت چیزی باشند.', 'پرسیارەکانی What بۆ پرسیار دەربارەی شت، بابەت، یان چەمک بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی ناو، جۆر، یان سروشتی شتێک بن.', 'What questions are used to ask about a thing, topic, or concept. These questions can be about name, type, or nature of something.', 16),

-- ساختار What
(@article_id, 'code', 'What + to be + Subject/Complement?\nExample: What is this? / What are you?', 'What + to be + Subject/Complement?\nExample: What is this? / What are you?', 'Structure: What + to be + Subject/Complement?\nExample: What is this? / What are you?', 17),

-- مثال‌های What
(@article_id, 'example', 'What is your name? - نام شما چیست؟ (کاربرد: پرسیدن نام)', 'What is your name? - ناوت چییە؟ (بەکارهێنان: پرسیار دەربارەی ناو)', 'What is your name? (Use: Asking name)', 18),

(@article_id, 'example', 'What is this? - این چیست؟ (کاربرد: پرسیدن ماهیت)', 'What is this? - ئەمە چییە؟ (بەکارهێنان: پرسیار دەربارەی سروشت)', 'What is this? (Use: Asking nature)', 19),

(@article_id, 'example', 'What are you? - شما چه چیزی هستید؟ (کاربرد: پرسیدن حرفه)', 'What are you? - تۆ چییت؟ (بەکارهێنان: پرسیار دەربارەی پیشە)', 'What are you? (Use: Asking profession)', 20),

-- تیتر Where Questions
(@article_id, 'subtitle', 'سوالات Where (کجا)', 'پرسیارەکانی Where (لە کوێ)', 'Where Questions', 21),

-- پاراگراف Where
(@article_id, 'paragraph', 'سوالات Where برای پرسیدن درباره مکان، موقعیت، یا محل استفاده می‌شوند. این سوالات می‌توانند درباره محل زندگی، کار، یا حضور باشند.', 'پرسیارەکانی Where بۆ پرسیار دەربارەی شوێن، شوێنەوە، یان شوێن بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی شوێنی ژیان، کار، یان بوون بن.', 'Where questions are used to ask about place, location, or position. These questions can be about residence, workplace, or presence.', 22),

-- ساختار Where
(@article_id, 'code', 'Where + to be + Subject?\nExample: Where are you? / Where is she?', 'Where + to be + Subject?\nExample: Where are you? / Where is she?', 'Structure: Where + to be + Subject?\nExample: Where are you? / Where is she?', 23),

-- مثال‌های Where
(@article_id, 'example', 'Where are you? - شما کجا هستید؟ (کاربرد: پرسیدن موقعیت فعلی)', 'Where are you? - تۆ لە کوێیت؟ (بەکارهێنان: پرسیار دەربارەی شوێنەوەی ئێستا)', 'Where are you? (Use: Asking current location)', 24),

(@article_id, 'example', 'Where is your home? - خانه شما کجاست؟ (کاربرد: پرسیدن محل زندگی)', 'Where is your home? - ماڵەوەت لە کوێیە؟ (بەکارهێنان: پرسیار دەربارەی شوێنی ژیان)', 'Where is your home? (Use: Asking residence)', 25),

(@article_id, 'example', 'Where are they? - آنها کجا هستند؟ (کاربرد: پرسیدن حضور گروه)', 'Where are they? - ئەوان لە کوێن؟ (بەکارهێنان: پرسیار دەربارەی بوونی کۆمەڵ)', 'Where are they? (Use: Asking group presence)', 26),

-- تیتر When Questions
(@article_id, 'subtitle', 'سوالات When (چه زمانی)', 'پرسیارەکانی When (کەی)', 'When Questions', 27),

-- پاراگراف When
(@article_id, 'paragraph', 'سوالات When برای پرسیدن درباره زمان، تاریخ، یا زمانبندی استفاده می‌شوند. این سوالات می‌توانند درباره زمان رویداد، برنامه، یا تاریخ باشند.', 'پرسیارەکانی When بۆ پرسیار دەربارەی کات، مێژوو، یان کاتی دیاریکراو بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی کاتی ڕووداو، پلان، یان مێژوو بن.', 'When questions are used to ask about time, date, or schedule. These questions can be about event time, program, or date.', 28),

-- ساختار When
(@article_id, 'code', 'When + to be + Subject/Event?\nExample: When is the meeting? / When are you free?', 'When + to be + Subject/Event?\nExample: When is the meeting? / When are you free?', 'Structure: When + to be + Subject/Event?\nExample: When is the meeting? / When are you free?', 29),

-- مثال‌های When
(@article_id, 'example', 'When is your birthday? - تولد شما چه زمانی است؟ (کاربرد: پرسیدن تاریخ)', 'When is your birthday? - لەدایکبوونت کەیە؟ (بەکارهێنان: پرسیار دەربارەی مێژوو)', 'When is your birthday? (Use: Asking date)', 30),

(@article_id, 'example', 'When is the meeting? - جلسه چه زمانی است؟ (کاربرد: پرسیدن زمان برنامه)', 'When is the meeting? - کۆبوونەوەکە کەیە؟ (بەکارهێنان: پرسیار دەربارەی کاتی پلان)', 'When is the meeting? (Use: Asking program time)', 31),

(@article_id, 'example', 'When are you free? - شما چه زمانی آزاد هستید؟ (کاربرد: پرسیدن زمان خالی)', 'When are you free? - تۆ کەی بەردەستیت؟ (بەکارهێنان: پرسیار دەربارەی کاتی بەتاڵ)', 'When are you free? (Use: Asking free time)', 32),

-- تیتر Why Questions
(@article_id, 'subtitle', 'سوالات Why (چرا)', 'پرسیارەکانی Why (بۆچی)', 'Why Questions', 33),

-- پاراگراف Why
(@article_id, 'paragraph', 'سوالات Why برای پرسیدن درباره دلیل، علت، یا هدف استفاده می‌شوند. این سوالات می‌توانند درباره انگیزه، دلیل تصمیم، یا علت وضعیت باشند.', 'پرسیارەکانی Why بۆ پرسیار دەربارەی هۆکار، سەبەب، یان ئامانج بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی پاڵنەر، هۆکاری بڕیار، یان سەبەبی دۆخ بن.', 'Why questions are used to ask about reason, cause, or purpose. These questions can be about motivation, decision reason, or situation cause.', 34),

-- ساختار Why
(@article_id, 'code', 'Why + to be + Subject/State?\nExample: Why are you sad? / Why is it important?', 'Why + to be + Subject/State?\nExample: Why are you sad? / Why is it important?', 'Structure: Why + to be + Subject/State?\nExample: Why are you sad? / Why is it important?', 35),

-- مثال‌های Why
(@article_id, 'example', 'Why are you sad? - چرا شما ناراحت هستید؟ (کاربرد: پرسیدن دلیل احساس)', 'Why are you sad? - بۆچی تۆ دڵتەنگیت؟ (بەکارهێنان: پرسیار دەربارەی هۆکاری هەست)', 'Why are you sad? (Use: Asking feeling reason)', 36),

(@article_id, 'example', 'Why is it important? - چرا این مهم است؟ (کاربرد: پرسیدن دلیل اهمیت)', 'Why is it important? - بۆچی گرنگە؟ (بەکارهێنان: پرسیار دەربارەی هۆکاری گرنگی)', 'Why is it important? (Use: Asking importance reason)', 37),

(@article_id, 'example', 'Why are they late? - چرا آنها دیر هستند؟ (کاربرد: پرسیدن دلیل تأخیر)', 'Why are they late? - بۆچی ئەوان دواکەوتن؟ (بەکارهێنان: پرسیار دەربارەی هۆکاری دواکەوتن)', 'Why are they late? (Use: Asking delay reason)', 38),

-- تیتر How Questions
(@article_id, 'subtitle', 'سوالات How (چطور)', 'پرسیارەکانی How (چۆن)', 'How Questions', 39),

-- پاراگراف How
(@article_id, 'paragraph', 'سوالات How برای پرسیدن درباره روش، حالت، یا کیفیت استفاده می‌شوند. این سوالات می‌توانند درباره نحوه انجام کار، وضعیت، یا میزان باشند.', 'پرسیارەکانی How بۆ پرسیار دەربارەی ڕێگە، دۆخ، یان چۆنیەتی بەکاردەهێنرێن. ئەم پرسیارانە دەتوانن دەربارەی چۆنیەتی ئەنجامدانی کار، دۆخ، یان بڕ بن.', 'How questions are used to ask about method, condition, or quality. These questions can be about how to do something, condition, or amount.', 40),

-- ساختار How
(@article_id, 'code', 'How + to be + Subject/State?\nExample: How are you? / How is the weather?', 'How + to be + Subject/State?\nExample: How are you? / How is the weather?', 'Structure: How + to be + Subject/State?\nExample: How are you? / How is the weather?', 41),

-- مثال‌های How
(@article_id, 'example', 'How are you? - شما چطور هستید؟ (کاربرد: پرسیدن حال)', 'How are you? - تۆ چۆنیت؟ (بەکارهێنان: پرسیار دەربارەی دۆخ)', 'How are you? (Use: Asking condition)', 42),

(@article_id, 'example', 'How is the weather? - هوا چطور است؟ (کاربرد: پرسیدن وضعیت)', 'How is the weather? - هەوا چۆنە؟ (بەکارهێنان: پرسیار دەربارەی دۆخ)', 'How is the weather? (Use: Asking condition)', 43),

(@article_id, 'example', 'How old are you? - شما چند ساله هستید؟ (کاربرد: پرسیدن سن)', 'How old are you? - تۆ چەند ساڵتە؟ (بەکارهێنان: پرسیار دەربارەی تەمەن)', 'How old are you? (Use: Asking age)', 44),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 45),

-- تیتر نکات مهم
(@article_id, 'subtitle', 'نکات مهم در سوالات WH', 'خاڵە گرنگەکان لە پرسیارەکانی WH', 'Important Points in WH Questions', 46),

-- نکات مهم
(@article_id, 'list', 'کلمه پرسشی همیشه در ابتدای جمله قرار می‌گیرد\nفعل to be بعد از کلمه پرسشی و قبل از فاعل می‌آید\nفاعل بعد از فعل to be قرار می‌گیرد\nجملات با علامت سوال (?) پایان می‌یابند\nدر پاسخ‌ها از ساختار عادی جمله استفاده می‌شود', 'وشەی پرسیار هەمیشە لە سەرەتای جملەدا دەکەوێت\nکرداری to be لە دوای وشەی پرسیار و لە پێش فاعل دەێت\nفاعل لە دوای کرداری to be دەکەوێت\nجملەکان بە نیشانەی پرسیار (?) کۆتایی دەهێنن\nلە وەڵامەکاندا لە پێکهاتەی ئاسایی جملە بەکاردەهێنرێت', 'Question word always comes at the beginning of the sentence\nto be verb comes after question word and before subject\nSubject comes after to be verb\nSentences end with question mark (?)\nAnswers use normal sentence structure', 47),

-- تیتر اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵە باوەکان', 'Common Mistakes', 48),

-- اشتباهات رایج
(@article_id, 'list', 'قرار دادن فاعل قبل از فعل to be\nفراموش کردن علامت سوال\nاستفاده نادرست از کلمات پرسشی\nترتیب نادرست کلمات در جمله\nفراموش کردن معکوس کردن فعل to be', 'دانانی فاعل لە پێش کرداری to be\nلەبیرکردنی نیشانەی پرسیار\nبەکارهێنانی هەڵەی وشەکانی پرسیار\nڕیزکردنی هەڵەی وشەکان لە جملەدا\nلەبیرکردنی پێچەوانەکردنی کرداری to be', 'Putting subject before to be verb\nForgetting question mark\nIncorrect use of question words\nWrong word order in sentence\nForgetting to invert to be verb', 49),

-- مثال‌های اشتباهات
(@article_id, 'example', '❌ You are where? → ✅ Where are you?\n❌ What your name is? → ✅ What is your name?\n❌ Who you are? → ✅ Who are you?', '❌ You are where? → ✅ Where are you?\n❌ What your name is? → ✅ What is your name?\n❌ Who you are? → ✅ Who are you?', '❌ You are where? → ✅ Where are you?\n❌ What your name is? → ✅ What is your name?\n❌ Who you are? → ✅ Who are you?', 50),

-- تیتر نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی', 'خاڵە بەکارهێنراوەکان', 'Practical Tips', 51),

-- نکات کاربردی
(@article_id, 'list', 'همیشه با کلمه پرسشی شروع کنید\nفعل to be را معکوس کنید\nبه ترتیب کلمات دقت کنید\nاز علامت سوال استفاده کنید\nتمرین مداوم با مثال‌های مختلف داشته باشید', 'هەمیشە بە وشەی پرسیار دەست پێبکە\nکرداری to be پێچەوانە بکە\nسەرنج بدە بە ڕیزکردنی وشەکان\nلە نیشانەی پرسیار بەکاربێنە\nڕاهێنانی بەردەوام لەگەڵ نموونەی جیاواز هەبێت', 'Always start with question word\nInvert the to be verb\nPay attention to word order\nUse question mark\nPractice regularly with different examples', 52),

-- نقل قول
(@article_id, 'quote', 'سوالات WH کلید درک و ارتباط در زبان انگلیسی هستند. تسلط بر این سوالات به شما کمک می‌کند تا اطلاعات دقیق‌تری کسب کنید.', 'پرسیارەکانی WH کلیلی تێگەهشتن و پەیوەندی لە زمانی ئینگلیزین. لێهاتوویی لەم پرسیارانە یارمەتیت دەدات تا زانیاری وردتر بەدەست بهێنیت.', 'WH questions are the key to understanding and communication in English. Mastering these questions helps you get more accurate information.', 53),

-- نکته مهم
(@article_id, 'note', 'برای یادگیری بهتر سوالات WH، سعی کنید در مکالمات روزانه از این سوالات استفاده کنید. تمرین مداوم و استفاده از مثال‌های واقعی به شما کمک می‌کند تا این ساختار را بهتر درک کنید.', 'بۆ فێربوونی باشتری پرسیارەکانی WH، هەوڵ بدە لە گفتوگۆی ڕۆژانەدا لەم پرسیارانە بەکاربێنیت. ڕاهێنانی بەردەوام و بەکارهێنانی نموونەی ڕاستەقینە یارمەتیت دەدات تا ئەم پێکهاتەیە باشتر لێکبەیتەوە.', 'To better learn WH questions, try to use these questions in daily conversations. Regular practice and using real examples will help you better understand this structure.', 54),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای تشخیص سوالات WH، به کلمات پرسشی در ابتدای جمله توجه کنید. اگر جمله با Who, What, Where, When, Why, How شروع شود، احتمالاً سوال WH است.', '💡 خاڵ: بۆ ناسینەوەی پرسیارەکانی WH، سەرنج بدە بە وشەکانی پرسیار لە سەرەتای جملە. ئەگەر جملە بە Who, What, Where, When, Why, How دەست پێبکات، لەوانەیە پرسیاری WH بێت.', '💡 Tip: To identify WH questions, pay attention to question words at the beginning of the sentence. If the sentence starts with Who, What, Where, When, Why, How, it is likely a WH question.', 55);
