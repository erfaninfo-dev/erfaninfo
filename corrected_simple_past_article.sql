-- مقاله جامع Simple Past - اصلاح شده
INSERT INTO articles (
    title_fa, title_ku, title_en, excerpt_fa, excerpt_ku, excerpt_en, tags_fa, tags_ku, tags_en, category, reading_time, is_published
) VALUES (
    '📚 Simple Past: گذشته ساده در انگلیسی',
    '📚 Simple Past: ڕابردووی سادە لە ئینگلیزیدا',
    '📚 Simple Past: The Simple Past Tense in English',
    'در این مقاله به بررسی کامل زمان گذشته ساده (Simple Past) در زبان انگلیسی می‌پردازیم. این زمان برای بیان اقدامات و رویدادهای تکمیل شده در گذشته استفاده می‌شود.',
    'لەم وتارەدا کاتی ڕابردووی سادە (Simple Past) لە زمانی ئینگلیزیدا بە شێوەیەکی گشتگیر تاوتوێ دەکەین. ئەم کاتە بۆ دەربڕینی کردار و ڕووداوە تەواوبووەکان لە ڕابردوودا بەکاردێت.',
    'In this article, we will thoroughly examine the Simple Past tense in English. This tense is used to express completed actions and events in the past.',
    'گرامر,Simple Past,گذشته ساده,افعال باقاعده,افعال بی‌قاعده',
    'گرامەر,Simple Past,ڕابردووی سادە,کردارە ڕێکەکان,کردارە ناڕێکەکان',
    'grammar,simple past,past tense,regular verbs,irregular verbs',
    'گرامر', 35, TRUE
);
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های محتوا
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num, block_metadata) VALUES

-- معرفی موضوع
(@article_id, 'subtitle', 'زمان گذشته ساده (Simple Past) چیست؟', 'کاتی ڕابردووی سادە (Simple Past) چییە؟', 'What is the Simple Past Tense?', 1, NULL),

(@article_id, 'paragraph', 'زمان گذشته ساده (Simple Past) یکی از پرکاربردترین زمان‌ها در زبان انگلیسی است که برای صحبت درباره‌ی کارها، رویدادها، شرایط و عادات تکمیل شده‌ای استفاده می‌شود که در زمان مشخصی در گذشته اتفاق افتاده‌اند. این زمان به ما کمک می‌کند تا داستان‌ها و اتفاقات گذشته را به وضوح بیان کنیم.', 'کاتی ڕابردووی سادە (Simple Past) یەکێکە لە کاتە هەرە باوەکان لە زمانی ئینگلیزیدا کە بۆ قسەکردن لەسەر کارەکان، ڕووداوەکان، بارودۆخەکان و خووە تەواوبووەکان بەکاردێت کە لە کاتێکی دیاریکراودا لە ڕابردوودا ڕوویانداوە. ئەم کاتە یارمەتیمان دەدات چیرۆک و ڕووداوەکانی ڕابردوو بە ڕوونی دەربڕین.', 'The Simple Past tense is one of the most commonly used tenses in English, used to talk about completed actions, events, situations, and habits that happened at a specific time in the past. It helps us clearly narrate stories and past occurrences.', 2, NULL),

-- کاربردها و موارد استفاده
(@article_id, 'subtitle', 'کاربردهای زمان گذشته ساده', 'بەکارهێنانەکانی کاتی ڕابردووی سادە', 'Uses of the Simple Past Tense', 3, NULL),

(@article_id, 'list', 'برای بیان عملی که در گذشته شروع شده و در گذشته به پایان رسیده است.', 'بۆ دەربڕینی کارێک کە لە ڕابردوودا دەستی پێکردووە و لە ڕابردوودا کۆتایی هاتووە.', 'To express an action that started and finished in the past.', 4, NULL),

(@article_id, 'example', 'I visited my grandparents last weekend. (من آخر هفته گذشته به دیدن پدربزرگ و مادربزرگم رفتم.)', 'I visited my grandparents last weekend. (من کۆتایی هەفتەی ڕابردوو سەردانی باپیر و نەنکم کرد.)', 'I visited my grandparents last weekend.', 5, NULL),

(@article_id, 'list', 'برای صحبت درباره عادت‌ها یا فعالیت‌های تکراری در گذشته.', 'بۆ قسەکردن لەسەر خووەکان یان چالاکییە دووبارەبووەکان لە ڕابردوودا.', 'To talk about habits or repeated actions in the past.', 6, NULL),

(@article_id, 'example', 'When I was a child, I played football every day. (وقتی بچه بودم، هر روز فوتبال بازی می‌کردم.)', 'When I was a child, I played football every day. (کاتێک من منداڵ بووم، هەموو ڕۆژێک تۆپی پێم دەکرد.)', 'When I was a child, I played football every day.', 7, NULL),

(@article_id, 'list', 'برای توصیف رویدادهای متوالی در یک داستان.', 'بۆ وەسفکردنی ڕووداوە یەک لە دوای یەکەکان لە چیرۆکێکدا.', 'To describe a series of events in a story.', 8, NULL),

(@article_id, 'example', 'She woke up, had breakfast, and then left for work. (او بیدار شد، صبحانه خورد و سپس به سمت کار رفت.)', 'She woke up, had breakfast, and then left for work. (ئەو لە خەو هەستا، نانی بەیانی خوارد، و پاشان بۆ کار ڕۆیشت.)', 'She woke up, had breakfast, and then left for work.', 9, NULL),

(@article_id, 'list', 'برای بیان حقایق یا شرایطی که در گذشته درست بودند اما اکنون دیگر نیستند.', 'بۆ دەربڕینی ڕاستییەکان یان بارودۆخەکان کە لە ڕابردوودا ڕاست بوون بەڵام ئێستا وانین.', 'To state facts or situations that were true in the past but are no longer true.', 10, NULL),

(@article_id, 'example', 'He lived in London for ten years. (او ده سال در لندن زندگی کرد.)', 'He lived in London for ten years. (ئەو بۆ ماوەی دە ساڵ لە لەندەن ژیا.)', 'He lived in London for ten years.', 11, NULL),

-- ساختار و فرمول
(@article_id, 'subtitle', 'ساختار و فرمول زمان گذشته ساده', 'پێکهاتە و فۆرموڵی کاتی ڕابردووی سادە', 'Structure and Formula of the Simple Past Tense', 12, NULL),

(@article_id, 'paragraph', 'ساختار کلی زمان گذشته ساده بسیار ساده است: فاعل + شکل دوم فعل. اما تفاوت اصلی در فعل‌های باقاعده (Regular Verbs) و بی‌قاعده (Irregular Verbs) است.', 'پێکهاتەی گشتی کاتی ڕابردووی سادە زۆر سادەیە: بکەر + شێوەی دووەمی کردار. بەڵام جیاوازی سەرەکی لە کردارە ڕێکەکان (Regular Verbs) و کردارە ناڕێکەکان (Irregular Verbs) دایە.', 'The general structure of the Simple Past tense is very simple: Subject + Past Form of the Verb. However, the main difference lies in Regular Verbs and Irregular Verbs.', 13, NULL),

(@article_id, 'subtitle', 'افعال باقاعده (Regular Verbs)', 'کردارە ڕێکەکان (Regular Verbs)', 'Regular Verbs', 14, NULL),

(@article_id, 'paragraph', 'برای ساختن زمان گذشته ساده با افعال باقاعده، معمولاً به انتهای فعل ریشه "-ed" اضافه می‌کنیم. اگر فعل به "e" ختم شود، فقط "-d" اضافه می‌کنیم.', 'بۆ دروستکردنی کاتی ڕابردووی سادە بە کردارە ڕێکەکان، بەزۆری "-ed" دەخەینە سەر کۆتایی کرداری بنەڕەتی. ئەگەر کردارەکە بە "e" کۆتایی بێت، تەنها "-d" زیاد دەکەین.', 'To form the Simple Past with regular verbs, we usually add "-ed" to the base form of the verb. If the verb ends in "e", we just add "-d".', 15, NULL),

(@article_id, 'example', 'Work → Worked (کار کردن)', 'Work → Worked (کار کردن)', 'Work → Worked', 16, NULL),
(@article_id, 'example', 'Play → Played (بازی کردن)', 'Play → Played (یاری کردن)', 'Play → Played', 17, NULL),
(@article_id, 'example', 'Live → Lived (زندگی کردن)', 'Live → Lived (ژیان کردن)', 'Live → Lived', 18, NULL),
(@article_id, 'example', 'Study → Studied (مطالعه کردن) - (اگر فعل به Y ختم شود و قبل از آن حرف بی‌صدا باشد، Y به I تبدیل شده و ed اضافه می‌شود)', 'Study → Studied (خوێندن) - (ئەگەر کردارەکە بە Y کۆتایی بێت و پیتی پێش Y بێدەنگ بێت، Y دەگۆڕێت بۆ I و ed زیاد دەکرێت)', 'Study → Studied (If the verb ends in Y preceded by a consonant, Y changes to I and -ed is added)', 19, NULL),

(@article_id, 'subtitle', 'افعال بی‌قاعده (Irregular Verbs)', 'کردارە ناڕێکەکان (Irregular Verbs)', 'Irregular Verbs', 20, NULL),

(@article_id, 'paragraph', 'افعال بی‌قاعده از قاعده خاصی پیروی نمی‌کنند و باید شکل گذشته آنها را حفظ کرد. این افعال تغییرات غیرقابل پیش‌بینی در املای خود دارند.', 'کردارە ناڕێکەکان پەیڕەوی هیچ یاسایەکی دیاریکراو ناکەن و دەبێت شێوەی ڕابردوویان لەبەر بکرێت. ئەم کردارانە گۆڕانکاریی پێشبینی نەکراو لە ڕێنووسیاندا هەیە.', 'Irregular verbs do not follow a specific rule, and their past forms must be memorized. These verbs have unpredictable changes in their spelling.', 21, NULL),

(@article_id, 'example', 'Go → Went (رفتن)', 'Go → Went (ڕۆیشتن)', 'Go → Went', 22, NULL),
(@article_id, 'example', 'See → Saw (دیدن)', 'See → Saw (بینین)', 'See → Saw', 23, NULL),
(@article_id, 'example', 'Eat → Ate (خوردن)', 'Eat → Ate (خواردن)', 'Eat → Ate', 24, NULL),
(@article_id, 'example', 'Have → Had (داشتن)', 'Have → Had (هەبوون)', 'Have → Had', 25, NULL),

-- انواع جمله
(@article_id, 'subtitle', 'انواع جمله در گذشته ساده', 'جۆرەکانی ڕستە لە ڕابردووی سادەدا', 'Sentence Types in Simple Past', 26, NULL),

(@article_id, 'paragraph', 'گذشته ساده می‌تواند در سه نوع جمله مثبت، منفی و سوالی استفاده شود. در جملات منفی و سوالی از فعل کمکی "did" استفاده می‌کنیم و فعل اصلی به شکل ساده خود برمی‌گردد.', 'ڕابردووی سادە دەتوانرێت لە سێ جۆر ڕستەدا بەکاربهێنرێت: ئەرێنی، نەرێنی و پرسیاری. لە ڕستە نەرێنی و پرسیارییەکاندا، کرداری یارمەتیدەری "did" بەکاردێنین و کرداری سەرەکی دەگەڕێتەوە بۆ شێوەی سادەی خۆی.', 'The Simple Past can be used in three types of sentences: affirmative, negative, and interrogative. In negative and interrogative sentences, we use the auxiliary verb "did" and the main verb returns to its base form.', 27, NULL),

(@article_id, 'subtitle', '1. جملات مثبت (Affirmative Sentences)', '1. ڕستە ئەرێنییەکان (Affirmative Sentences)', '1. Affirmative Sentences', 28, NULL),

(@article_id, 'paragraph', 'فاعل + شکل گذشته فعل (V2)', 'بکەر + شێوەی ڕابردووی کردار (V2)', 'Subject + Past form of the verb (V2)', 29, NULL),

(@article_id, 'example', 'She watched a movie last night. (او دیشب یک فیلم تماشا کرد.)', 'She watched a movie last night. (ئەو دوێنێ شەو فیلمێکی سەیر کرد.)', 'She watched a movie last night.', 30, NULL),
(@article_id, 'example', 'We went to the beach yesterday. (ما دیروز به ساحل رفتیم.)', 'We went to the beach yesterday. (ئێمە دوێنێ چووین بۆ کەنار دەریا.)', 'We went to the beach yesterday.', 31, NULL),

(@article_id, 'subtitle', '2. جملات منفی (Negative Sentences)', '2. ڕستە نەرێنییەکان (Negative Sentences)', '2. Negative Sentences', 32, NULL),

(@article_id, 'paragraph', 'فاعل + did not (didn''t) + شکل ساده فعل (V1)', 'بکەر + did not (didn''t) + شێوەی سادەی کردار (V1)', 'Subject + did not (didn''t) + Base form of the verb (V1)', 33, NULL),

(@article_id, 'example', 'He didn''t study for the exam. (او برای امتحان درس نخواند.)', 'He didn''t study for the exam. (ئەو بۆ تاقیکردنەوەکە نەخوێند.)', 'He didn''t study for the exam.', 34, NULL),
(@article_id, 'example', 'They did not come to the party. (آن‌ها به مهمانی نیامدند.)', 'They did not come to the party. (ئەوان نەهاتن بۆ ئاهەنگەکە.)', 'They did not come to the party.', 35, NULL),

(@article_id, 'subtitle', '3. جملات سوالی (Interrogative Sentences)', '3. ڕستە پرسیارییەکان (Interrogative Sentences)', '3. Interrogative Sentences', 36, NULL),

(@article_id, 'paragraph', 'Did + فاعل + شکل ساده فعل (V1)؟', 'Did + بکەر + شێوەی سادەی کردار (V1)؟', 'Did + Subject + Base form of the verb (V1)?', 37, NULL),

(@article_id, 'example', 'Did you finish your homework? (آیا تکالیفت را تمام کردی؟)', 'Did you finish your homework? (ئایا کاری ماڵەوەت تەواو کرد؟)', 'Did you finish your homework?', 38, NULL),
(@article_id, 'example', 'Did she call you yesterday? (آیا او دیروز به تو زنگ زد؟)', 'Did she call you yesterday? (ئایا ئەو دوێنێ پەیوەندی پێوە کردیت؟)', 'Did she call you yesterday?', 39, NULL),

(@article_id, 'paragraph', 'همچنین برای سوالات اطلاعاتی از کلمات پرسشی (Wh-words) استفاده می‌کنیم:', 'هەروەها بۆ پرسیارە زانیارییەکان وشەکانی پرسیار (Wh-words) بەکاردێنین:', 'Also, for information questions, we use Wh-words:', 40, NULL),

(@article_id, 'example', 'Where did you go last night? (دیشب کجا رفتی؟)', 'Where did you go last night? (دوێنێ شەو بۆ کوێ ڕۆیشتی؟)', 'Where did you go last night?', 41, NULL),
(@article_id, 'example', 'What did they eat for dinner? (آن‌ها برای شام چه خوردند؟)', 'What did they eat for dinner? (ئەوان بۆ نانی ئێوارە چیان خوارد؟)', 'What did they eat for dinner?', 42, NULL),

-- کلمات نشانه (Signal Words)
(@article_id, 'subtitle', 'کلمات نشانه (Signal Words)', 'وشەکانی نیشاندەر (Signal Words)', 'Signal Words', 43, NULL),

(@article_id, 'paragraph', 'کلمات نشانه به شما کمک می‌کنند تا زمان گذشته ساده را در جملات تشخیص دهید. این کلمات معمولاً به زمان مشخصی در گذشته اشاره دارند.', 'وشەکانی نیشاندەر یارمەتیت دەدەن کاتی ڕابردووی سادە لە ڕستەکاندا بناسیتەوە. ئەم وشانە بەزۆری ئاماژە بە کاتێکی دیاریکراو لە ڕابردوودا دەکەن.', 'Signal words help you identify the Simple Past tense in sentences. These words usually refer to a specific time in the past.', 44, NULL),

(@article_id, 'list', 'Yesterday (دیروز): I saw him yesterday. (من دیروز او را دیدم.)', 'Yesterday (دوێنێ): I saw him yesterday. (من دوێنێ بینیم.)', 'Yesterday: I saw him yesterday.', 45, '{"direction": "ltr", "position": "left"}'),
(@article_id, 'list', 'Last night/week/month/year (دیشب/هفته گذشته/ماه گذشته/سال گذشته): We went to a concert last week. (ما هفته گذشته به کنسرت رفتیم.)', 'Last night/week/month/year (دوێنێ شەو/هەفتەی ڕابردوو/مانگی ڕابردوو/ساڵی ڕابردوو): We went to a concert last week. (ئێمە هەفتەی ڕابردوو چووین بۆ کۆنسێرتێک.)', 'Last night/week/month/year: We went to a concert last week.', 46, '{"direction": "ltr", "position": "left"}'),
(@article_id, 'list', 'Ago (قبل): She moved here two years ago. (او دو سال پیش به اینجا نقل مکان کرد.)', 'Ago (پێش): She moved here two years ago. (ئەو دوو ساڵ پێش ئێستا گواسترایەوە ئێرە.)', 'Ago: She moved here two years ago.', 47, '{"direction": "ltr", "position": "left"}'),
(@article_id, 'list', 'In [year] (در سال [سال]): My parents met in 1990. (والدین من در سال 1990 با هم آشنا شدند.)', 'In [year] (لە [ساڵ]): My parents met in 1990. (دایک و باوکم لە ساڵی 1990 یەکتریان ناسی.)', 'In [year]: My parents met in 1990.', 48, '{"direction": "ltr", "position": "left"}'),
(@article_id, 'list', 'When I was young/a child (وقتی جوان بودم/بچه بودم): When I was young, I loved to read. (وقتی جوان بودم، عاشق مطالعه بودم.)', 'When I was young/a child (کاتێک گەنج بووم/منداڵ بووم): When I was young, I loved to read. (کاتێک گەنج بووم، حەزم لە خوێندنەوە بوو.)', 'When I was young/a child: When I was young, I loved to read.', 49, '{"direction": "ltr", "position": "left"}'),

-- اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج در استفاده از Simple Past', 'هەڵە باوەکان لە بەکارهێنانی Simple Past', 'Common Mistakes in Using Simple Past', 50, NULL),

(@article_id, 'list', 'استفاده از شکل گذشته فعل همراه با "did/didn''t": Did you went? (اشتباه) → Did you go? (صحیح)', 'بەکارهێنانی شێوەی ڕابردووی کردار لەگەڵ "did/didn''t": Did you went? (هەڵە) → Did you go? (ڕاست)', 'Using the past form of the verb with "did/didn''t": Did you went? (Incorrect) → Did you go? (Correct)', 51, NULL),
(@article_id, 'list', 'اشتباه گرفتن افعال باقاعده و بی‌قاعده: He buyed a new car. (اشتباه) → He bought a new car. (صحیح)', 'تێکەڵکردنی کردارە ڕێکەکان و ناڕێکەکان: He buyed a new car. (هەڵە) → He bought a new car. (ڕاست)', 'Confusing regular and irregular verbs: He buyed a new car. (Incorrect) → He bought a new car. (Correct)', 52, NULL),
(@article_id, 'list', 'فراموش کردن "d" یا "ed" برای افعال باقاعده: She play tennis yesterday. (اشتباه) → She played tennis yesterday. (صحیح)', 'بیرچوونەوەی "d" یان "ed" بۆ کردارە ڕێکەکان: She play tennis yesterday. (هەڵە) → She played tennis yesterday. (ڕاست)', 'Forgetting "d" or "ed" for regular verbs: She play tennis yesterday. (Incorrect) → She played tennis yesterday. (Correct)', 53, NULL),
(@article_id, 'list', 'استفاده از Simple Past برای عملی که هنوز به زمان حال مرتبط است (باید از Present Perfect استفاده شود).', 'بەکارهێنانی Simple Past بۆ کارێک کە هێشتا پەیوەندی بە ئێستاوە هەیە (دەبێت Present Perfect بەکاربهێنرێت).', 'Using Simple Past for an action still relevant to the present (should use Present Perfect).', 54, NULL),

-- نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی برای یادگیری Simple Past', 'خاڵە بەکارهێنراوەکان بۆ فێربوونی Simple Past', 'Practical Tips for Learning Simple Past', 55, NULL),

(@article_id, 'list', 'لیستی افعال بی‌قاعده را حفظ کنید. می‌توانید از فلش‌کارت یا اپلیکیشن‌های آموزشی استفاده کنید.', 'لیستی کردارە ناڕێکەکان لەبەر بکە. دەتوانیت کارتی فلاش یان ئەپڵیکەیشنە فێرکارییەکان بەکاربهێنیت.', 'Memorize the list of irregular verbs. You can use flashcards or learning apps.', 56, NULL),
(@article_id, 'list', 'داستان‌های کوتاه یا خاطرات گذشته خود را به زبان انگلیسی بنویسید تا این زمان را تمرین کنید.', 'چیرۆکی کورت یان بیرەوەرییەکانی ڕابردووی خۆت بە زمانی ئینگلیزی بنووسە بۆ ئەوەی ئەم کاتە ڕابهێنیت.', 'Write short stories or your past memories in English to practice this tense.', 57, NULL),
(@article_id, 'list', 'به پادکست‌ها و ویدئوهای آموزشی گوش دهید که از این زمان استفاده می‌کنند.', 'گوێ لە پۆدکاست و ڤیدیۆ فێرکارییەکان بگرە کە ئەم کاتە بەکاردەهێنن.', 'Listen to podcasts and educational videos that use this tense.', 58, NULL),
(@article_id, 'list', 'با دوستان یا هم‌کلاسی‌های خود درباره‌ی اتفاقات روز گذشته یا خاطرات قدیمی صحبت کنید.', 'لەگەڵ هاوڕێیان یان هاوپۆلەکانت قسە لەسەر ڕووداوەکانی دوێنێ یان بیرەوەرییە کۆنەکان بکە.', 'Talk with friends or classmates about yesterday''s events or old memories.', 59, NULL),

-- نکته مهم
(@article_id, 'note', 'نکته: تسلط بر زمان گذشته ساده برای روایت داستان‌ها، تجربیات و وقایع تاریخی ضروری است. زمان بگذارید تا افعال بی‌قاعده را بیاموزید و تمرین کنید.', 'تێبینی: شارەزابوون لە کاتی ڕابردووی سادە بۆ گێڕانەوەی چیرۆکەکان، ئەزموونەکان و ڕووداوە مێژووییەکان پێویستە. کات تەرخان بکە بۆ فێربوون و ڕاهێنانی کردارە ناڕێکەکان.', 'Note: Mastering the Simple Past tense is essential for narrating stories, experiences, and historical events. Take time to learn and practice irregular verbs.', 60, NULL);
