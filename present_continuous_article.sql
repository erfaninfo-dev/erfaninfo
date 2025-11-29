-- مقاله جامع Present Continuous
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
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES

-- معرفی
(@article_id, 'subtitle', 'زمان حال استمراری چیست؟', 'کاتی ئێستای بەردەوام چییە؟', 'What is Present Continuous?', 1),

(@article_id, 'paragraph', 'زمان حال استمراری (Present Continuous) یکی از مهم‌ترین زمان‌های زبان انگلیسی است که برای بیان فعالیت‌هایی استفاده می‌شود که در لحظه صحبت در حال انجام هستند. این زمان با استفاده از فعل کمکی "to be" و شکل "-ing" فعل اصلی ساخته می‌شود.', 'کاتی ئێستای بەردەوام (Present Continuous) یەکێکە لە گرنگترین کاتەکانی زمانی ئینگلیزی کە بۆ باسکردنی چالاکییەکانی بەکار دەهێنرێت کە لە کاتی قسەکردن لە کاتی ئێستادا ئەنجام دەدرێن. ئەم کاتە بە بەکارهێنانی کرداری یارمەتیدەری "to be" و شێوەی "-ing" کرداری سەرەکی دروست دەکرێت.', 'Present Continuous tense is one of the most important tenses in English used to express activities that are happening at the moment of speaking. This tense is formed using the auxiliary verb "to be" and the "-ing" form of the main verb.', 2),

-- کاربردها
(@article_id, 'subtitle', 'کاربردهای زمان حال استمراری', 'بەکارهێنانەکانی کاتی ئێستای بەردەوام', 'Uses of Present Continuous', 3),

(@article_id, 'paragraph', 'زمان حال استمراری در موارد زیر استفاده می‌شود:', 'کاتی ئێستای بەردەوام لە حاڵەتەکانی خوارەوە بەکار دەهێنرێت:', 'Present Continuous is used in the following cases:', 4),

(@article_id, 'paragraph', '• فعالیت‌هایی که در لحظه صحبت در حال انجام هستند\n• فعالیت‌هایی که در دوره زمانی مشخصی در حال انجام هستند\n• برنامه‌های آینده که از قبل برنامه‌ریزی شده‌اند\n• شکایت و نارضایتی از عادت‌های تکراری\n• تغییرات و روندهای در حال پیشرفت', '• چالاکییەکانی کە لە کاتی قسەکردن لە کاتی ئێستادا ئەنجام دەدرێن\n• چالاکییەکانی کە لە ماوەیەکی دیاریکراوی کاتدا ئەنجام دەدرێن\n• پڕۆگرامەکانی داهاتوو کە لە پێشدا پلانداریان بۆ کراوە\n• سکاڵا و نەدڵەتی لە خووە دووبارەکان\n• گۆڕانکاری و ڕێڕەوەکانی بەردەوام لە پێشکەوتن', '• Activities happening at the moment of speaking\n• Activities happening over a specific period of time\n• Future plans that are already arranged\n• Complaints about repeated habits\n• Changes and ongoing trends', 5),

-- ساختار
(@article_id, 'subtitle', 'ساختار زمان حال استمراری', 'پێکهاتەی کاتی ئێستای بەردەوام', 'Structure of Present Continuous', 6),

(@article_id, 'paragraph', 'ساختار کلی زمان حال استمراری به صورت زیر است:', 'پێکهاتەی گشتی کاتی ئێستای بەردەوام بەم شێوەیەیە:', 'The general structure of Present Continuous is as follows:', 7),

(@article_id, 'example', 'Subject + am/is/are + verb + ing', 'Subject + am/is/are + verb + ing', 'Subject + am/is/are + verb + ing', 8),

-- نوع جمله
(@article_id, 'subtitle', 'نوع جمله', 'جۆری جملە', 'Sentence Types', 9),

-- جمله مثبت
(@article_id, 'subtitle', 'جمله مثبت', 'جملەی ئەرێنی', 'Affirmative Sentences', 10),

(@article_id, 'paragraph', 'در جمله مثبت، فعل کمکی "to be" با توجه به فاعل انتخاب می‌شود و فعل اصلی به شکل "-ing" می‌آید.', 'لە جملەی ئەرێنیدا، کرداری یارمەتیدەری "to be" بە پێی فاعل هەڵدەبژێردرێت و کرداری سەرەکی بە شێوەی "-ing" دەردەکەوێت.', 'In affirmative sentences, the auxiliary verb "to be" is chosen according to the subject and the main verb comes in "-ing" form.', 11),

(@article_id, 'example', 'I am studying English. - من دارم انگلیسی می‌خوانم.\nYou are working hard. - تو داری سخت کار می‌کنی.\nHe is playing football. - او دارد فوتبال بازی می‌کند.\nShe is cooking dinner. - او دارد شام می‌پزد.\nIt is raining. - باران می‌بارد.\nWe are watching TV. - ما داریم تلویزیون تماشا می‌کنیم.\nThey are sleeping. - آنها دارند می‌خوابند.', 'I am studying English. - من خوێندنی ئینگلیزی دەکەم.\nYou are working hard. - تۆ بە زەحمەت کار دەکەیت.\nHe is playing football. - ئەو یاری تۆپی پێ دەکات.\nShe is cooking dinner. - ئەو چێشت لێنان دەکات.\nIt is raining. - باران دەبارێت.\nWe are watching TV. - ئێمە تەلەفزیۆن سەیر دەکەین.\nThey are sleeping. - ئەوان خەوتن.', 'I am studying English.\nYou are working hard.\nHe is playing football.\nShe is cooking dinner.\nIt is raining.\nWe are watching TV.\nThey are sleeping.', 12),

-- جمله منفی
(@article_id, 'subtitle', 'جمله منفی', 'جملەی نەرێنی', 'Negative Sentences', 13),

(@article_id, 'paragraph', 'در جمله منفی، "not" بعد از فعل کمکی "to be" قرار می‌گیرد.', 'لە جملەی نەرێنیدا، "not" دوای کرداری یارمەتیدەری "to be" دەکەوێت.', 'In negative sentences, "not" comes after the auxiliary verb "to be".', 14),

(@article_id, 'example', 'I am not studying English. - من دارم انگلیسی نمی‌خوانم.\nYou are not working hard. - تو داری سخت کار نمی‌کنی.\nHe is not playing football. - او دارد فوتبال بازی نمی‌کند.\nShe is not cooking dinner. - او دارد شام نمی‌پزد.\nIt is not raining. - باران نمی‌بارد.\nWe are not watching TV. - ما داریم تلویزیون تماشا نمی‌کنیم.\nThey are not sleeping. - آنها دارند نمی‌خوابند.', 'I am not studying English. - من خوێندنی ئینگلیزی ناکەم.\nYou are not working hard. - تۆ بە زەحمەت کار ناکەیت.\nHe is not playing football. - ئەو یاری تۆپی پێ ناکات.\nShe is not cooking dinner. - ئەو چێشت لێنان ناکات.\nIt is not raining. - باران نابارێت.\nWe are not watching TV. - ئێمە تەلەفزیۆن سەیر ناکەین.\nThey are not sleeping. - ئەوان ناخەون.', 'I am not studying English.\nYou are not working hard.\nHe is not playing football.\nShe is not cooking dinner.\nIt is not raining.\nWe are not watching TV.\nThey are not sleeping.', 15),

-- جمله سوالی
(@article_id, 'subtitle', 'جمله سوالی', 'جملەی پرسیار', 'Interrogative Sentences', 16),

(@article_id, 'paragraph', 'در جمله سوالی، فعل کمکی "to be" قبل از فاعل قرار می‌گیرد.', 'لە جملەی پرسیاردا، کرداری یارمەتیدەری "to be" پێش فاعل دەکەوێت.', 'In interrogative sentences, the auxiliary verb "to be" comes before the subject.', 17),

(@article_id, 'example', 'Am I studying English? - آیا من دارم انگلیسی می‌خوانم؟\nAre you working hard? - آیا تو داری سخت کار می‌کنی؟\nIs he playing football? - آیا او دارد فوتبال بازی می‌کند؟\nIs she cooking dinner? - آیا او دارد شام می‌پزد؟\nIs it raining? - آیا باران می‌بارد؟\nAre we watching TV? - آیا ما داریم تلویزیون تماشا می‌کنیم؟\nAre they sleeping? - آیا آنها دارند می‌خوابند؟', 'Am I studying English? - ئایا من خوێندنی ئینگلیزی دەکەم؟\nAre you working hard? - ئایا تۆ بە زەحمەت کار دەکەیت؟\nIs he playing football? - ئایا ئەو یاری تۆپی پێ دەکات؟\nIs she cooking dinner? - ئایا ئەو چێشت لێنان دەکات؟\nIs it raining? - ئایا باران دەبارێت؟\nAre we watching TV? - ئایا ئێمە تەلەفزیۆن سەیر دەکەین؟\nAre they sleeping? - ئایا ئەوان خەوتن؟', 'Am I studying English?\nAre you working hard?\nIs he playing football?\nIs she cooking dinner?\nIs it raining?\nAre we watching TV?\nAre they sleeping?', 18),

-- کلمات نشانه
(@article_id, 'subtitle', 'کلمات نشانه', 'وشەکانی نیشاندەر', 'Signal Words', 19),

(@article_id, 'paragraph', 'کلمات زیر نشان‌دهنده استفاده از زمان حال استمراری هستند:', 'وشەکانی خوارەوە نیشاندەری بەکارهێنانی کاتی ئێستای بەردەوومن:', 'The following words indicate the use of Present Continuous tense:', 20),

(@article_id, 'example', '• now - حالا\n• at the moment - در این لحظه\n• at present - در حال حاضر\n• currently - در حال حاضر\n• right now - همین الان\n• today - امروز\n• this week - این هفته\n• this month - این ماه\n• this year - امسال\n• these days - این روزها', '• now - ئێستا\n• at the moment - لەم ساتەدا\n• at present - لە کاتی ئێستادا\n• currently - لە کاتی ئێستادا\n• right now - ئێستا\n• today - ئەمڕۆ\n• this week - ئەم هەفتەیە\n• this month - ئەم مانگە\n• this year - ئەم ساڵە\n• these days - ئەم ڕۆژانە', '• now\n• at the moment\n• at present\n• currently\n• right now\n• today\n• this week\n• this month\n• this year\n• these days', 21),

-- مثال‌های بیشتر
(@article_id, 'subtitle', 'مثال‌های بیشتر', 'مثالە زیاترەکان', 'More Examples', 22),

(@article_id, 'example', 'I am reading a book now. - من دارم کتاب می‌خوانم.\nShe is studying for her exam at the moment. - او دارد برای امتحانش درس می‌خواند.\nThey are building a new house this year. - آنها دارند خانه جدیدی می‌سازند.\nWe are learning English these days. - ما داریم این روزها انگلیسی یاد می‌گیریم.\nHe is working on a new project currently. - او دارد روی پروژه جدیدی کار می‌کند.', 'I am reading a book now. - من کتێب دەخوێنمەوە.\nShe is studying for her exam at the moment. - ئەو بۆ تاقیکردنەوەکەی خوێندن دەکات.\nThey are building a new house this year. - ئەوان ماڵێکی نوێ دروست دەکەن.\nWe are learning English these days. - ئێمە ئەم ڕۆژانە ئینگلیزی فێردەبین.\nHe is working on a new project currently. - ئەو لەسەر پڕۆژەیەکی نوێ کار دەکات.', 'I am reading a book now.\nShe is studying for her exam at the moment.\nThey are building a new house this year.\nWe are learning English these days.\nHe is working on a new project currently.', 23),

-- اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج', 'هەڵەکانی باو', 'Common Mistakes', 24),

(@article_id, 'paragraph', 'اشتباهات رایج در استفاده از زمان حال استمراری:', 'هەڵەکانی باو لە بەکارهێنانی کاتی ئێستای بەردەوام:', 'Common mistakes in using Present Continuous tense:', 25),

(@article_id, 'example', '• فراموش کردن فعل کمکی "to be"\n• استفاده نادرست از شکل "-ing"\n• استفاده از زمان حال استمراری برای حقایق کلی\n• فراموش کردن "not" در جمله منفی\n• استفاده نادرست از کلمات نشانه', '• لەبیرکردنی کرداری یارمەتیدەری "to be"\n• بەکارهێنانی هەڵەی شێوەی "-ing"\n• بەکارهێنانی کاتی ئێستای بەردەوام بۆ ڕاستییە گشتییەکان\n• لەبیرکردنی "not" لە جملەی نەرێنی\n• بەکارهێنانی هەڵەی وشەکانی نیشاندەر', '• Forgetting the auxiliary verb "to be"\n• Incorrect use of "-ing" form\n• Using Present Continuous for general facts\n• Forgetting "not" in negative sentences\n• Incorrect use of signal words', 26),

-- نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی', 'خاڵە بەکارهێنراوەکان', 'Practical Tips', 27),

(@article_id, 'paragraph', 'برای یادگیری بهتر زمان حال استمراری:', 'بۆ فێربوونی باشتری کاتی ئێستای بەردەوام:', 'For better learning of Present Continuous tense:', 28),

(@article_id, 'example', '• همیشه فعل کمکی "to be" را اضافه کنید\n• به شکل "-ing" فعل اصلی دقت کنید\n• از کلمات نشانه برای تشخیص استفاده کنید\n• تمرین مداوم با مثال‌های مختلف داشته باشید\n• به تفاوت با زمان حال ساده توجه کنید', '• هەمیشە کرداری یارمەتیدەری "to be" زیاد بکە\n• سەرنج بدە بە شێوەی "-ing" کرداری سەرەکی\n• لە وشەکانی نیشاندەر بۆ ناسینەوە بەکار بهێنە\n• ڕاهێنان بەردەوام لەگەڵ نموونە جیاوازەکان هەبە\n• سەرنج بدە بە جیاوازی لەگەڵ کاتی ئێستای سادە', '• Always add the auxiliary verb "to be"\n• Pay attention to the "-ing" form of the main verb\n• Use signal words for identification\n• Have continuous practice with different examples\n• Pay attention to the difference with Present Simple', 29),

-- نقل قول
(@article_id, 'paragraph', 'زمان حال استمراری ابزار قدرتمندی برای بیان فعالیت‌های در حال انجام است. تسلط بر این زمان به شما کمک می‌کند تا ارتباط مؤثرتری داشته باشید.', 'کاتی ئێستای بەردەوام ئامرازێکی بەهێزە بۆ باسکردنی چالاکییەکانی بەردەوام لە ئەنجام. شارەزایی لەم کاتە یارمەتیت دەدات بۆ پەیوەندی کاریگەرتر.', 'Present Continuous is a powerful tool for expressing ongoing activities. Mastering this tense helps you have more effective communication.', 30),

-- نکته
(@article_id, 'note', 'نکته: برای تشخیص زمان حال استمراری، به وجود فعل کمکی "to be" و شکل "-ing" فعل اصلی توجه کنید. اگر جمله بیان‌کننده فعالیتی در حال انجام باشد، احتمالاً از این زمان استفاده شده است.', 'خاڵ: بۆ ناسینەوەی کاتی ئێستای بەردەوام، سەرنج بدە بە بوونی کرداری یارمەتیدەری "to be" و شێوەی "-ing" کرداری سەرەکی. ئەگەر جملە باسکردنی چالاکییەک بێت لە کاتی ئەنجام، لەوانەیە لەم کاتە بەکارهێنراوە.', 'Note: To identify Present Continuous tense, pay attention to the presence of auxiliary verb "to be" and "-ing" form of the main verb. If the sentence expresses an ongoing activity, it is likely using this tense.', 31);
