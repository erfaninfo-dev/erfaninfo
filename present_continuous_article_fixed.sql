-- مقاله جامع Present Continuous - اصلاح شده
INSERT INTO articles (
    title_fa, title_ku, title_en, excerpt_fa, excerpt_ku, excerpt_en, tags_fa, tags_ku, tags_en, category, reading_time, is_published
) VALUES (
    '📚 Present Continuous: زمان حال استمراری',
    '📚 Present Continuous: کاتی ئێستای بەردەوام',
    '📚 Present Continuous: Present Continuous Tense',
    'در این مقاله به بررسی کامل زمان حال استمراری می‌پردازیم. این زمان برای بیان فعالیت‌هایی که در حال انجام هستند استفاده می‌شود.',
    'لەم وتارەدا کاتی ئێستای بەردەوام بە وردەکاری بەدوادا دەکەین. ئەم کاتە بۆ باسکردنی چالاکییەکانی کە لە کاتی ئێستادا ئەنجام دەدرێن بەکار دەهێنرێت.',
    'In this article, we examine the Present Continuous tense comprehensively. This tense is used to express activities that are currently happening.',
    'گرامر,Present Continuous,زمان حال استمراری',
    'گرامەر,Present Continuous,کاتی ئێستای بەردەوام',
    'grammar,present continuous,continuous tense',
    'گرامر', 30, TRUE
);
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های محتوا
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num, block_metadata) VALUES

-- معرفی
(@article_id, 'subtitle', 'زمان حال استمراری چیست؟', 'کاتی ئێستای بەردەوام چییە؟', 'What is Present Continuous?', 1, NULL),

(@article_id, 'paragraph', 'زمان حال استمراری (Present Continuous) یکی از مهم‌ترین زمان‌های زبان انگلیسی است که برای بیان فعالیت‌هایی استفاده می‌شود که در لحظه صحبت در حال انجام هستند. این زمان با استفاده از فعل کمکی "to be" و شکل "-ing" فعل اصلی ساخته می‌شود.', 'کاتی ئێستای بەردەوام (Present Continuous) یەکێکە لە گرنگترین کاتەکانی زمانی ئینگلیزی کە بۆ باسکردنی چالاکییەکانی بەکار دەهێنرێت کە لە کاتی قسەکردن لە کاتی ئێستادا ئەنجام دەدرێن. ئەم کاتە بە بەکارهێنانی کرداری یارمەتیدەری "to be" و شێوەی "-ing" کرداری سەرەکی دروست دەکرێت.', 'Present Continuous tense is one of the most important tenses in English used to express activities that are happening at the moment of speaking. This tense is formed using the auxiliary verb "to be" and the "-ing" form of the main verb.', 2, NULL),

-- کاربردها
(@article_id, 'subtitle', 'کاربردهای زمان حال استمراری', 'بەکارهێنانەکانی کاتی ئێستای بەردەوام', 'Uses of Present Continuous', 3, NULL),

(@article_id, 'paragraph', 'زمان حال استمراری در موارد زیر استفاده می‌شود:', 'کاتی ئێستای بەردەوام لە حاڵەتەکانی خوارەوە بەکار دەهێنرێت:', 'Present Continuous is used in the following cases:', 4, NULL),

(@article_id, 'paragraph', '• فعالیت‌هایی که در لحظه صحبت در حال انجام هستند\n• فعالیت‌هایی که در دوره زمانی مشخصی در حال انجام هستند\n• برنامه‌های آینده که از قبل برنامه‌ریزی شده‌اند\n• شکایت و نارضایتی از عادت‌های تکراری\n• تغییرات و روندهای در حال پیشرفت', '• چالاکییەکانی کە لە کاتی قسەکردن لە کاتی ئێستادا ئەنجام دەدرێن\n• چالاکییەکانی کە لە ماوەیەکی دیاریکراوی کاتدا ئەنجام دەدرێن\n• پڕۆگرامەکانی داهاتوو کە لە پێشدا پلانداریان بۆ کراوە\n• سکاڵا و نەدڵەتی لە خووە دووبارەکان\n• گۆڕانکاری و ڕێڕەوەکانی بەردەوام لە پێشکەوتن', '• Activities happening at the moment of speaking\n• Activities happening over a specific period of time\n• Future plans that are already arranged\n• Complaints about repeated habits\n• Changes and ongoing trends', 5, NULL),

-- ساختار
(@article_id, 'subtitle', 'ساختار زمان حال استمراری', 'پێکهاتەی کاتی ئێستای بەردەوام', 'Structure of Present Continuous', 6, NULL),

(@article_id, 'paragraph', 'ساختار کلی زمان حال استمراری به صورت زیر است:', 'پێکهاتەی گشتی کاتی ئێستای بەردەوام بەم شێوەیەیە:', 'The general structure of Present Continuous is as follows:', 7, NULL),

(@article_id, 'example', 'Subject + am/is/are + verb + ing', 'Subject + am/is/are + verb + ing', 'Subject + am/is/are + verb + ing', 8, NULL),

-- نوع جمله
(@article_id, 'subtitle', 'نوع جمله', 'جۆری جملە', 'Sentence Types', 9, NULL),

-- جمله مثبت
(@article_id, 'subtitle', 'جمله مثبت', 'جملەی ئەرێنی', 'Affirmative Sentences', 10, NULL),

(@article_id, 'paragraph', 'در جمله مثبت، فعل کمکی "to be" با توجه به فاعل انتخاب می‌شود و فعل اصلی به شکل "-ing" می‌آید.', 'لە جملەی ئەرێنیدا، کرداری یارمەتیدەری "to be" بە پێی فاعل هەڵدەبژێردرێت و کرداری سەرەکی بە شێوەی "-ing" دەردەکەوێت.', 'In affirmative sentences, the auxiliary verb "to be" is chosen according to the subject and the main verb comes in "-ing" form.', 11, NULL),

(@article_id, 'example', 'I am studying English. - من دارم انگلیسی می‌خوانم.', 'I am studying English. - من خوێندنی ئینگلیزی دەکەم.', 'I am studying English.', 12, NULL),

(@article_id, 'example', 'You are working hard. - تو داری سخت کار می‌کنی.', 'You are working hard. - تۆ بە زەحمەت کار دەکەیت.', 'You are working hard.', 13, NULL),

(@article_id, 'example', 'He is playing football. - او دارد فوتبال بازی می‌کند.', 'He is playing football. - ئەو یاری تۆپی پێ دەکات.', 'He is playing football.', 14, NULL),

(@article_id, 'example', 'She is cooking dinner. - او دارد شام می‌پزد.', 'She is cooking dinner. - ئەو چێشت لێنان دەکات.', 'She is cooking dinner.', 15, NULL),

(@article_id, 'example', 'It is raining. - باران می‌بارد.', 'It is raining. - باران دەبارێت.', 'It is raining.', 16, NULL),

(@article_id, 'example', 'We are watching TV. - ما داریم تلویزیون تماشا می‌کنیم.', 'We are watching TV. - ئێمە تەلەفزیۆن سەیر دەکەین.', 'We are watching TV.', 17, NULL),

(@article_id, 'example', 'They are sleeping. - آنها دارند می‌خوابند.', 'They are sleeping. - ئەوان خەوتن.', 'They are sleeping.', 18, NULL),

-- جمله منفی
(@article_id, 'subtitle', 'جمله منفی', 'جملەی نەرێنی', 'Negative Sentences', 19, NULL),

(@article_id, 'paragraph', 'در جمله منفی، "not" بعد از فعل کمکی "to be" قرار می‌گیرد.', 'لە جملەی نەرێنیدا، "not" دوای کرداری یارمەتیدەری "to be" دەکەوێت.', 'In negative sentences, "not" comes after the auxiliary verb "to be".', 20, NULL),

(@article_id, 'example', 'I am not studying English. - من دارم انگلیسی نمی‌خوانم.', 'I am not studying English. - من خوێندنی ئینگلیزی ناکەم.', 'I am not studying English.', 21, NULL),

(@article_id, 'example', 'You are not working hard. - تو داری سخت کار نمی‌کنی.', 'You are not working hard. - تۆ بە زەحمەت کار ناکەیت.', 'You are not working hard.', 22, NULL),

(@article_id, 'example', 'He is not playing football. - او دارد فوتبال بازی نمی‌کند.', 'He is not playing football. - ئەو یاری تۆپی پێ ناکات.', 'He is not playing football.', 23, NULL),

(@article_id, 'example', 'She is not cooking dinner. - او دارد شام نمی‌پزد.', 'She is not cooking dinner. - ئەو چێشت لێنان ناکات.', 'She is not cooking dinner.', 24, NULL),

(@article_id, 'example', 'It is not raining. - باران نمی‌بارد.', 'It is not raining. - باران نابارێت.', 'It is not raining.', 25, NULL),

(@article_id, 'example', 'We are not watching TV. - ما داریم تلویزیون تماشا نمی‌کنیم.', 'We are not watching TV. - ئێمە تەلەفزیۆن سەیر ناکەین.', 'We are not watching TV.', 26, NULL),

(@article_id, 'example', 'They are not sleeping. - آنها دارند نمی‌خوابند.', 'They are not sleeping. - ئەوان ناخەون.', 'They are not sleeping.', 27, NULL),

-- جمله سوالی
(@article_id, 'subtitle', 'جمله سوالی', 'جملەی پرسیار', 'Interrogative Sentences', 28, NULL),

(@article_id, 'paragraph', 'در جمله سوالی، فعل کمکی "to be" قبل از فاعل قرار می‌گیرد.', 'لە جملەی پرسیاردا، کرداری یارمەتیدەری "to be" پێش فاعل دەکەوێت.', 'In interrogative sentences, the auxiliary verb "to be" comes before the subject.', 29, NULL),

(@article_id, 'example', 'Am I studying English? - آیا من دارم انگلیسی می‌خوانم؟', 'Am I studying English? - ئایا من خوێندنی ئینگلیزی دەکەم؟', 'Am I studying English?', 30, NULL),

(@article_id, 'example', 'Are you working hard? - آیا تو داری سخت کار می‌کنی؟', 'Are you working hard? - ئایا تۆ بە زەحمەت کار دەکەیت؟', 'Are you working hard?', 31, NULL),

(@article_id, 'example', 'Is he playing football? - آیا او دارد فوتبال بازی می‌کند؟', 'Is he playing football? - ئایا ئەو یاری تۆپی پێ دەکات؟', 'Is he playing football?', 32, NULL),

(@article_id, 'example', 'Is she cooking dinner? - آیا او دارد شام می‌پزد؟', 'Is she cooking dinner? - ئایا ئەو چێشت لێنان دەکات؟', 'Is she cooking dinner?', 33, NULL),

(@article_id, 'example', 'Is it raining? - آیا باران می‌بارد؟', 'Is it raining? - ئایا باران دەبارێت؟', 'Is it raining?', 34, NULL),

(@article_id, 'example', 'Are we watching TV? - آیا ما داریم تلویزیون تماشا می‌کنیم؟', 'Are we watching TV? - ئایا ئێمە تەلەفزیۆن سەیر دەکەین؟', 'Are we watching TV?', 35, NULL),

(@article_id, 'example', 'Are they sleeping? - آیا آنها دارند می‌خوابند؟', 'Are they sleeping? - ئایا ئەوان خەوتن؟', 'Are they sleeping?', 36, NULL),

-- کلمات نشانه
(@article_id, 'subtitle', 'کلمات نشانه', 'وشەکانی نیشاندەر', 'Signal Words', 37, NULL),

(@article_id, 'paragraph', 'کلمات زیر نشان‌دهنده استفاده از زمان حال استمراری هستند:', 'وشەکانی خوارەوە نیشاندەری بەکارهێنانی کاتی ئێستای بەردەوومن:', 'The following words indicate the use of Present Continuous tense:', 38, NULL),

-- کلمات نشانه در بلاک‌های جداگانه list
(@article_id, 'list', 'now - حالا: I am reading a book now. - من دارم کتاب می‌خوانم.', 'now - ئێستا: I am reading a book now. - من کتێب دەخوێنمەوە.', 'now - now: I am reading a book now.', 39, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'at the moment - در این لحظه: She is studying for her exam at the moment. - او دارد برای امتحانش درس می‌خواند.', 'at the moment - لەم ساتەدا: She is studying for her exam at the moment. - ئەو بۆ تاقیکردنەوەکەی خوێندن دەکات.', 'at the moment - at the moment: She is studying for her exam at the moment.', 40, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'at present - در حال حاضر: They are working on a new project at present. - آنها دارند روی پروژه جدیدی کار می‌کنند.', 'at present - لە کاتی ئێستادا: They are working on a new project at present. - ئەوان لەسەر پڕۆژەیەکی نوێ کار دەکەن.', 'at present - at present: They are working on a new project at present.', 41, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'currently - در حال حاضر: He is currently learning Spanish. - او دارد اسپانیایی یاد می‌گیرد.', 'currently - لە کاتی ئێستادا: He is currently learning Spanish. - ئەو ئێستا ئیسپانی فێردەبێت.', 'currently - currently: He is currently learning Spanish.', 42, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'right now - همین الان: We are having dinner right now. - ما داریم شام می‌خوریم.', 'right now - ئێستا: We are having dinner right now. - ئێمە ئێستا نان خواردن دەکەین.', 'right now - right now: We are having dinner right now.', 43, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'today - امروز: I am going to the gym today. - من دارم امروز به باشگاه می‌روم.', 'today - ئەمڕۆ: I am going to the gym today. - من ئەمڕۆ دەچم بۆ هۆڵی وەرزش.', 'today - today: I am going to the gym today.', 44, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'this week - این هفته: They are traveling to Paris this week. - آنها دارند این هفته به پاریس سفر می‌کنند.', 'this week - ئەم هەفتەیە: They are traveling to Paris this week. - ئەوان ئەم هەفتەیە دەچن بۆ پاریس.', 'this week - this week: They are traveling to Paris this week.', 45, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'this month - این ماه: She is taking a course this month. - او دارد این ماه یک دوره می‌گذراند.', 'this month - ئەم مانگە: She is taking a course this month. - ئەو ئەم مانگە کۆرسێک دەخوێنێت.', 'this month - this month: She is taking a course this month.', 46, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'this year - امسال: We are building a new house this year. - ما داریم امسال خانه جدیدی می‌سازیم.', 'this year - ئەم ساڵە: We are building a new house this year. - ئێمە ئەم ساڵە ماڵێکی نوێ دروست دەکەین.', 'this year - this year: We are building a new house this year.', 47, '{"direction": "ltr", "position": "left"}'),

(@article_id, 'list', 'these days - این روزها: People are using more technology these days. - مردم این روزها بیشتر از تکنولوژی استفاده می‌کنند.', 'these days - ئەم ڕۆژانە: People are using more technology these days. - خەڵک ئەم ڕۆژانە زیاتر تەکنەلۆجی بەکار دەهێنن.', 'these days - these days: People are using more technology these days.', 48, '{"direction": "ltr", "position": "left"}'),

-- مثال‌های بیشتر
(@article_id, 'subtitle', 'مثال‌های بیشتر', 'مثالە زیاترەکان', 'More Examples', 49, NULL),

(@article_id, 'example', 'I am reading a book now. - من دارم کتاب می‌خوانم.', 'I am reading a book now. - من کتێب دەخوێنمەوە.', 'I am reading a book now.', 50, NULL),

(@article_id, 'example', 'She is studying for her exam at the moment. - او دارد برای امتحانش درس می‌خواند.', 'She is studying for her exam at the moment. - ئەو بۆ تاقیکردنەوەکەی خوێندن دەکات.', 'She is studying for her exam at the moment.', 51, NULL),

(@article_id, 'example', 'They are building a new house this year. - آنها دارند خانه جدیدی می‌سازند.', 'They are building a new house this year. - ئەوان ماڵێکی نوێ دروست دەکەن.', 'They are building a new house this year.', 52, NULL),

(@article_id, 'example', 'We are learning English these days. - ما داریم این روزها انگلیسی یاد می‌گیریم.', 'We are learning English these days. - ئێمە ئەم ڕۆژانە ئینگلیزی فێردەبین.', 'We are learning English these days.', 53, NULL),

(@article_id, 'example', 'He is working on a new project currently. - او دارد روی پروژه جدیدی کار می‌کند.', 'He is working on a new project currently. - ئەو لەسەر پڕۆژەیەکی نوێ کار دەکات.', 'He is working on a new project currently.', 54, NULL),

-- اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵەکانی باو', 'Common Mistakes', 55, NULL),

(@article_id, 'paragraph', 'اشتباهات رایج در استفاده از زمان حال استمراری:', 'هەڵەکانی باو لە بەکارهێنانی کاتی ئێستای بەردەوام:', 'Common mistakes in using Present Continuous tense:', 56, NULL),

(@article_id, 'list', 'فراموش کردن فعل کمکی "to be"', 'لەبیرکردنی کرداری یارمەتیدەری "to be"', 'Forgetting the auxiliary verb "to be"', 57, NULL),

(@article_id, 'list', 'استفاده نادرست از شکل "-ing"', 'بەکارهێنانی هەڵەی شێوەی "-ing"', 'Incorrect use of "-ing" form', 58, NULL),

(@article_id, 'list', 'استفاده از زمان حال استمراری برای حقایق کلی', 'بەکارهێنانی کاتی ئێستای بەردەوام بۆ ڕاستییە گشتییەکان', 'Using Present Continuous for general facts', 59, NULL),

(@article_id, 'list', 'فراموش کردن "not" در جمله منفی', 'لەبیرکردنی "not" لە جملەی نەرێنی', 'Forgetting "not" in negative sentences', 60, NULL),

(@article_id, 'list', 'استفاده نادرست از کلمات نشانه', 'بەکارهێنانی هەڵەی وشەکانی نیشاندەر', 'Incorrect use of signal words', 61, NULL),

-- نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی', 'خاڵە بەکارهێنراوەکان', 'Practical Tips', 62, NULL),

(@article_id, 'paragraph', 'برای یادگیری بهتر زمان حال استمراری:', 'بۆ فێربوونی باشتری کاتی ئێستای بەردەوام:', 'For better learning of Present Continuous tense:', 63, NULL),

(@article_id, 'list', 'همیشه فعل کمکی "to be" را اضافه کنید', 'هەمیشە کرداری یارمەتیدەری "to be" زیاد بکە', 'Always add the auxiliary verb "to be"', 64, NULL),

(@article_id, 'list', 'به شکل "-ing" فعل اصلی دقت کنید', 'سەرنج بدە بە شێوەی "-ing" کرداری سەرەکی', 'Pay attention to the "-ing" form of the main verb', 65, NULL),

(@article_id, 'list', 'از کلمات نشانه برای تشخیص استفاده کنید', 'لە وشەکانی نیشاندەر بۆ ناسینەوە بەکار بهێنە', 'Use signal words for identification', 66, NULL),

(@article_id, 'list', 'تمرین مداوم با مثال‌های مختلف داشته باشید', 'ڕاهێنان بەردەوام لەگەڵ نموونە جیاوازەکان هەبە', 'Have continuous practice with different examples', 67, NULL),

(@article_id, 'list', 'به تفاوت با زمان حال ساده توجه کنید', 'سەرنج بدە بە جیاوازی لەگەڵ کاتی ئێستای سادە', 'Pay attention to the difference with Present Simple', 68, NULL),

-- نقل قول
(@article_id, 'paragraph', 'زمان حال استمراری ابزار قدرتمندی برای بیان فعالیت‌های در حال انجام است. تسلط بر این زمان به شما کمک می‌کند تا ارتباط مؤثرتری داشته باشید.', 'کاتی ئێستای بەردەوام ئامرازێکی بەهێزە بۆ باسکردنی چالاکییەکانی بەردەوام لە ئەنجام. شارەزایی لەم کاتە یارمەتیت دەدات بۆ پەیوەندی کاریگەرتر.', 'Present Continuous is a powerful tool for expressing ongoing activities. Mastering this tense helps you have more effective communication.', 69, NULL),

-- نکته
(@article_id, 'note', 'نکته: برای تشخیص زمان حال استمراری، به وجود فعل کمکی "to be" و شکل "-ing" فعل اصلی توجه کنید. اگر جمله بیان‌کننده فعالیتی در حال انجام باشد، احتمالاً از این زمان استفاده شده است.', 'خاڵ: بۆ ناسینەوەی کاتی ئێستای بەردەوام، سەرنج بدە بە بوونی کرداری یارمەتیدەری "to be" و شێوەی "-ing" کرداری سەرەکی. ئەگەر جملە باسکردنی چالاکییەک بێت لە کاتی ئەنجام، لەوانەیە لەم کاتە بەکارهێنراوە.', 'Note: To identify Present Continuous tense, pay attention to the presence of auxiliary verb "to be" and "-ing" form of the main verb. If the sentence expresses an ongoing activity, it is likely using this tense.', 70, NULL);
