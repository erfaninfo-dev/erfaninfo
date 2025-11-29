-- مقاله Present Simple: to be verbs
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
    '📚 Present Simple: افعال to be',
    '📚 Present Simple: کردارەکانی to be',
    '📚 Present Simple: to be verbs',
    'در این مقاله به بررسی جامع افعال to be در زمان حال ساده می‌پردازیم. این افعال پایه و اساس ساختار جملات انگلیسی هستند.',
    'لەم وتارەدا بەدوادا دەکەین بۆ کردارەکانی to be لە کاتی ئێستا. ئەم کردارانە بنەڕەت و پێکهاتەی جملەکانی ئینگلیزین.',
    'In this article, we examine the comprehensive use of to be verbs in Present Simple tense. These verbs are the foundation of English sentence structure.',
    'گرامر,Present Simple,to be,زمان انگلیسی,آموزش',
    'گرامەر,Present Simple,to be,زمانی ئینگلیزی,فێرکاری',
    'grammar,present simple,to be,english tenses,learning',
    'گرامر',
    18,
    TRUE
);

-- دریافت ID مقاله
SET @article_id = LAST_INSERT_ID();

-- بلاک‌های مقاله را اضافه می‌کنیم
INSERT INTO article_blocks (article_id, block_type, content_fa, content_ku, content_en, order_num) VALUES
-- تیتر اصلی
(@article_id, 'subtitle', 'Present Simple چیست؟', 'Present Simple چییە؟', 'What is Present Simple?', 1),

-- پاراگراف معرفی
(@article_id, 'paragraph', 'Present Simple یکی از مهم‌ترین زمان‌های انگلیسی است که برای بیان عادات، حقایق، روال‌های روزمره و شرایط دائمی استفاده می‌شود. در این مقاله به طور خاص روی افعال to be تمرکز می‌کنیم که پایه و اساس ساختار جملات انگلیسی هستند.', 'Present Simple یەکێکە لە گرنگترین کاتەکانی ئینگلیزی کە بۆ باسکردنی خوو، ڕاستی، ڕەوەڕەوە ڕۆژانەکان و دۆخە بەردەوامەکان بەکاردەهێنرێت. لەم وتارەدا بەتایبەتی لەسەر کردارەکانی to be کۆنترۆڵ دەکەین کە بنەڕەت و پێکهاتەی جملەکانی ئینگلیزین.', 'Present Simple is one of the most important English tenses used to express habits, facts, daily routines, and permanent conditions. In this article, we specifically focus on to be verbs which are the foundation of English sentence structure.', 2),

-- تیتر کاربردها
(@article_id, 'subtitle', 'کاربردهای Present Simple', 'بەکارهێنانەکانی Present Simple', 'Uses of Present Simple', 3),

-- لیست کاربردها
(@article_id, 'list', 'عادات و روال‌های روزمره\nحقایق و اطلاعات عمومی\nبرنامه‌های ثابت (مثل برنامه قطار)\nاحساسات و عقاید\nشرایط دائمی و علمی', 'خوو و ڕەوەڕەوە ڕۆژانەکان\nڕاستی و زانیاری گشتی\nپڕۆگرامە بەردەوامەکان (وەک پڕۆگرامی شەمەندەفەر)\nهەست و بۆچوونەکان\nدۆخە بەردەوام و زانستییەکان', 'Daily habits and routines\nGeneral facts and information\nFixed schedules (like train timetables)\nFeelings and opinions\nPermanent and scientific conditions', 4),

-- تیتر افعال to be
(@article_id, 'subtitle', 'افعال to be در زمان حال ساده', 'کردارەکانی to be لە کاتی ئێستا', 'To be verbs in Present Simple', 5),

-- پاراگراف افعال to be
(@article_id, 'paragraph', 'افعال to be شامل am، is و are هستند که به ترتیب برای فاعل‌های I، he/she/it و you/we/they استفاده می‌شوند. این افعال برای بیان حالت، موقعیت، ویژگی‌ها و هویت استفاده می‌شوند.', 'کردارەکانی to be پێکدێن لە am، is و are کە بەپێی ڕیزبەندی بۆ فاعلەکانی I، he/she/it و you/we/they بەکارهێنرێن. ئەم کردارانە بۆ باسکردنی دۆخ، شوێن، تایبەتمەندییەکان و ناسنامە بەکارهێنرێن.', 'To be verbs include am, is, and are which are used for subjects I, he/she/it, and you/we/they respectively. These verbs are used to express state, position, characteristics, and identity.', 6),

-- کد ساختار to be
(@article_id, 'code', 'I am (من هستم)\nYou are (تو هستی)\nHe/She/It is (او هست)\nWe are (ما هستیم)\nYou are (شما هستید)\nThey are (آنها هستند)', 'I am (من هەم)\nYou are (تۆ هەیت)\nHe/She/It is (ئەو هەیە)\nWe are (ئێمە هەین)\nYou are (ئێوە هەن)\nThey are (ئەوان هەن)', 'I am (I am)\nYou are (You are)\nHe/She/It is (He/She/It is)\nWe are (We are)\nYou are (You are)\nThey are (They are)', 7),

-- تیتر انواع جملات
(@article_id, 'subtitle', 'انواع جملات با افعال to be', 'جۆرەکانی جملە بە کردارەکانی to be', 'Types of Sentences with to be verbs', 8),

-- تیتر جملات مثبت
(@article_id, 'subtitle', 'جملات مثبت (Affirmative)', 'جملە ئەرێنییەکان (Affirmative)', 'Affirmative Sentences', 9),

-- توضیح جملات مثبت
(@article_id, 'paragraph', 'جملات مثبت با افعال to be به سادگی با قرار دادن فعل to be بعد از فاعل ساخته می‌شوند. این جملات برای بیان حقایق، ویژگی‌ها و شرایط استفاده می‌شوند.', 'جملە ئەرێنییەکان بە کردارەکانی to be بە سادەیی بە دانانی کردارەکانی to be دوای فاعل دروست دەکرێن. ئەم جملانە بۆ باسکردنی ڕاستی، تایبەتمەندییەکان و دۆخەکان بەکارهێنرێن.', 'Affirmative sentences with to be verbs are simply formed by placing the to be verb after the subject. These sentences are used to express facts, characteristics, and conditions.', 10),

-- ساختار جملات مثبت
(@article_id, 'code', 'Subject + to be + Complement\nمثال: I am a student.', 'Subject + to be + Complement\nنموونە: I am a student.', 'Structure: Subject + to be + Complement\nExample: I am a student.', 11),

-- مثال‌های جملات مثبت
(@article_id, 'example', 'I am happy. - من خوشحال هستم. (کاربرد: احساسات)', 'I am happy. - من دڵخۆشم. (بەکارهێنان: هەست)', 'I am happy. - I am happy. (Use: Feelings)', 12),

(@article_id, 'example', 'She is a doctor. - او پزشک است. (کاربرد: حرفه)', 'She is a doctor. - ئەو دکتۆرە. (بەکارهێنان: پیشە)', 'She is a doctor. - She is a doctor. (Use: Profession)', 13),

(@article_id, 'example', 'They are students. - آنها دانشجو هستند. (کاربرد: هویت)', 'They are students. - ئەوان قوتابیین. (بەکارهێنان: ناسنامە)', 'They are students. - They are students. (Use: Identity)', 14),

(@article_id, 'example', 'We are in Tehran. - ما در تهران هستیم. (کاربرد: موقعیت)', 'We are in Tehran. - ئێمە لە تەهرانین. (بەکارهێنان: شوێن)', 'We are in Tehran. - We are in Tehran. (Use: Location)', 15),

(@article_id, 'example', 'It is cold today. - امروز سرد است. (کاربرد: شرایط)', 'It is cold today. - ئەمڕۆ ساردە. (بەکارهێنان: دۆخ)', 'It is cold today. - It is cold today. (Use: Condition)', 16),

-- تیتر جملات منفی
(@article_id, 'subtitle', 'جملات منفی (Negative)', 'جملە نەرێنییەکان (Negative)', 'Negative Sentences', 17),

-- توضیح جملات منفی
(@article_id, 'paragraph', 'جملات منفی با اضافه کردن not بعد از فعل to be ساخته می‌شوند. این جملات برای بیان عدم وجود، عدم تعلق یا عدم تطابق استفاده می‌شوند.', 'جملە نەرێنییەکان بە زیادکردنی not دوای کردارەکانی to be دروست دەکرێن. ئەم جملانە بۆ باسکردنی نەبوون، نەبوونی پەیوەندی یان نەبوونی گونجاندن بەکارهێنرێن.', 'Negative sentences are formed by adding not after the to be verb. These sentences are used to express absence, non-belonging, or non-conformity.', 18),

-- ساختار جملات منفی
(@article_id, 'code', 'Subject + to be + not + Complement\nمثال: I am not tired.', 'Subject + to be + not + Complement\nنموونە: I am not tired.', 'Structure: Subject + to be + not + Complement\nExample: I am not tired.', 19),

-- مثال‌های جملات منفی
(@article_id, 'example', 'I am not hungry. - من گرسنه نیستم. (کاربرد: احساسات)', 'I am not hungry. - من برسی نیم. (بەکارهێنان: هەست)', 'I am not hungry. - I am not hungry. (Use: Feelings)', 20),

(@article_id, 'example', 'He is not a teacher. - او معلم نیست. (کاربرد: حرفه)', 'He is not a teacher. - ئەو مامۆستا نییە. (بەکارهێنان: پیشە)', 'He is not a teacher. - He is not a teacher. (Use: Profession)', 21),

(@article_id, 'example', 'They are not here. - آنها اینجا نیستند. (کاربرد: موقعیت)', 'They are not here. - ئەوان لێرە نین. (بەکارهێنان: شوێن)', 'They are not here. - They are not here. (Use: Location)', 22),

(@article_id, 'example', 'She is not busy. - او مشغول نیست. (کاربرد: شرایط)', 'She is not busy. - ئەو سەرقاڵ نییە. (بەکارهێنان: دۆخ)', 'She is not busy. - She is not busy. (Use: Condition)', 23),

(@article_id, 'example', 'We are not late. - ما دیر نیستیم. (کاربرد: زمان)', 'We are not late. - ئێمە دواکەوتوو نین. (بەکارهێنان: کات)', 'We are not late. - We are not late. (Use: Time)', 24),

-- تیتر جملات سوالی
(@article_id, 'subtitle', 'جملات سوالی (Interrogative)', 'جملە پرسیارەکان (Interrogative)', 'Interrogative Sentences', 25),

-- توضیح جملات سوالی
(@article_id, 'paragraph', 'جملات سوالی با قرار دادن فعل to be در ابتدای جمله ساخته می‌شوند. این جملات برای پرسیدن سوالات بله/خیر یا اطلاعاتی استفاده می‌شوند.', 'جملە پرسیارەکان بە دانانی کردارەکانی to be لە سەرەتای جملە دروست دەکرێن. ئەم جملانە بۆ پرسیارکردنی پرسیارە بەڵێ/نەخێر یان زانیاری بەکارهێنرێن.', 'Interrogative sentences are formed by placing the to be verb at the beginning of the sentence. These sentences are used to ask yes/no questions or information questions.', 26),

-- ساختار جملات سوالی
(@article_id, 'code', 'To be + Subject + Complement?\nمثال: Are you ready?', 'To be + Subject + Complement?\nنموونە: Are you ready?', 'Structure: To be + Subject + Complement?\nExample: Are you ready?', 27),

-- مثال‌های جملات سوالی
(@article_id, 'example', 'Are you tired? - آیا تو خسته‌ای؟ (کاربرد: احساسات)', 'Are you tired? - ئایا تۆ ماندوویت؟ (بەکارهێنان: هەست)', 'Are you tired? - Are you tired? (Use: Feelings)', 28),

(@article_id, 'example', 'Is she a doctor? - آیا او پزشک است؟ (کاربرد: حرفه)', 'Is she a doctor? - ئایا ئەو دکتۆرە؟ (بەکارهێنان: پیشە)', 'Is she a doctor? - Is she a doctor? (Use: Profession)', 29),

(@article_id, 'example', 'Are they students? - آیا آنها دانشجو هستند؟ (کاربرد: هویت)', 'Are they students? - ئایا ئەوان قوتابیین؟ (بەکارهێنان: ناسنامە)', 'Are they students? - Are they students? (Use: Identity)', 30),

(@article_id, 'example', 'Is it cold? - آیا سرد است؟ (کاربرد: شرایط)', 'Is it cold? - ئایا ساردە؟ (بەکارهێنان: دۆخ)', 'Is it cold? - Is it cold? (Use: Condition)', 31),

(@article_id, 'example', 'Are we late? - آیا ما دیر هستیم؟ (کاربرد: زمان)', 'Are we late? - ئایا ئێمە دواکەوتووین؟ (بەکارهێنان: کات)', 'Are we late? - Are we late? (Use: Time)', 32),

-- خط جداکننده
(@article_id, 'divider', '', '', '', 33),

-- تیتر کلمات نشانه
(@article_id, 'subtitle', 'کلمات نشانه با افعال to be', 'وشە نیشاندەرەکان بە کردارەکانی to be', 'Signal Words with to be verbs', 34),

-- لیست کلمات نشانه با مثال‌های to be
(@article_id, 'list', 'always - همیشه: I am always happy. (من همیشه خوشحال هستم.)\nusually - معمولاً: She is usually busy. (او معمولاً مشغول است.)\noften - اغلب: They are often late. (آنها اغلب دیر می‌رسند.)\nsometimes - گاهی: He is sometimes tired. (او گاهی خسته است.)\nrarely - به ندرت: We are rarely sick. (ما به ندرت بیمار می‌شویم.)\nnever - هرگز: I am never angry. (من هرگز عصبانی نیستم.)', 'always - هەمیشە: I am always happy. (من هەمیشە دڵخۆشم.)\nusually - بەگشتی: She is usually busy. (ئەو بەگشتی سەرقاڵە.)\noften - زۆربەی کات: They are often late. (ئەوان زۆربەی کات دواکەوتوون.)\nsometimes - هەندێک جار: He is sometimes tired. (ئەو هەندێک جار ماندووە.)\nrarely - بە دەگمە: We are rarely sick. (ئێمە بە دەگمە نەخۆش دەبین.)\nnever - هەرگیز: I am never angry. (من هەرگیز توڕە نیم.)', 'always - always: I am always happy. (I am always happy.)\nusually - usually: She is usually busy. (She is usually busy.)\noften - often: They are often late. (They are often late.)\nsometimes - sometimes: He is sometimes tired. (He is sometimes tired.)\nrarely - rarely: We are rarely sick. (We are rarely sick.)\nnever - never: I am never angry. (I am never angry.)', 35),

-- نکته مهم
(@article_id, 'note', 'این کلمات نشانه به شما کمک می‌کنند تا تشخیص دهید که باید از Present Simple با افعال to be استفاده کنید. هر کلمه نشانه با نوع متفاوتی از جمله (مثبت، منفی، سوالی) استفاده شده است.', 'ئەم وشە نیشاندەرانە یارمەتیت دەدەن تا دیاری بکەیت کە دەبێت لە Present Simple لەگەڵ کردارەکانی to be بەکاربێنیت. هەر وشەیەک نیشاندەر لەگەڵ جۆری جیاوازی جملە (ئەرێنی، نەرێنی، پرسیار) بەکارهێنراوە.', 'These signal words help you identify when to use Present Simple with to be verbs. Each signal word is used with a different type of sentence (affirmative, negative, interrogative).', 36),

-- تیتر اشتباهات رایج
(@article_id, 'subtitle', 'اشتباهات رایج با افعال to be', 'هەڵە باوەکان لەگەڵ کردارەکانی to be', 'Common Mistakes with to be verbs', 37),

-- لیست اشتباهات
(@article_id, 'list', 'استفاده از am برای فاعل‌های سوم شخص: I am → He am (غلط)\nفراموش کردن are برای فاعل‌های جمع: They is → They are (غلط)\nاستفاده نادرست از is برای I: I is → I am (غلط)\nفراموش کردن not در جملات منفی: I am tired → I am not tired\nاستفاده نادرست از do/does با to be: Do you are → Are you (غلط)', 'بەکارهێنانی am بۆ فاعلە سێیەم کەسەکان: I am → He am (هەڵە)\nلەبیرکردنی are بۆ فاعلە کۆکراوەکان: They is → They are (هەڵە)\nبەکارهێنانی هەڵەی is بۆ I: I is → I am (هەڵە)\nلەبیرکردنی not لە جملە نەرێنییەکان: I am tired → I am not tired\nبەکارهێنانی هەڵەی do/does لەگەڵ to be: Do you are → Are you (هەڵە)', 'Using am for third person subjects: I am → He am (wrong)\nForgetting are for plural subjects: They is → They are (wrong)\nIncorrect use of is for I: I is → I am (wrong)\nForgetting not in negative sentences: I am tired → I am not tired\nIncorrect use of do/does with to be: Do you are → Are you (wrong)', 38),

-- نکته مهم
(@article_id, 'note', 'برای جلوگیری از این اشتباهات، همیشه به یاد داشته باشید که am فقط برای I، is برای he/she/it و are برای you/we/they استفاده می‌شود.', 'بۆ ڕێگریکردن لەم هەڵانە، هەمیشە لەبیرت بێت کە am تەنها بۆ I، is بۆ he/she/it و are بۆ you/we/they بەکارهێنرێت.', 'To avoid these mistakes, always remember that am is only for I, is for he/she/it, and are for you/we/they.', 39),

-- تیتر نکات کاربردی
(@article_id, 'subtitle', 'نکات کاربردی برای تسلط', 'خاڵە بەکارهێنراوەکان بۆ لێهاتوویی', 'Practical Tips for Mastery', 40),

-- لیست نکات کاربردی
(@article_id, 'list', 'هر روز جملات با to be بسازید\nاز کلمات نشانه استفاده کنید\nبا خودتان صحبت کنید\nمکالمات روزمره را تمرین کنید\nاز کتاب‌های آموزشی استفاده کنید', 'هەر ڕۆژ جملە بە to be دروست بکە\nلە وشە نیشاندەرەکان بەکاربێنە\nلەگەڵ خۆت قسە بکە\nگفتوگۆی ڕۆژانە ڕاهێنان بکە\nلە کتێبە فێرکارییەکان بەکاربێنە', 'Make sentences with to be every day\nUse signal words\nTalk to yourself\nPractice daily conversations\nUse educational books', 41),

-- نقل قول
(@article_id, 'quote', 'Present Simple پایه و اساس زبان انگلیسی است. تسلط بر این زمان کلید موفقیت در یادگیری زبان است.', 'Present Simple بنەڕەت و پێکهاتەی زمانی ئینگلیزییە. لێهاتوویی لەم کاتە کلیلی سەرکەوتنە لە فێربوونی زمان.', 'Present Simple is the foundation of English. Mastering this tense is the key to success in language learning.', 42),

-- کادر ویژه
(@article_id, 'callout', '💡 نکته: برای یادگیری بهتر افعال to be، سعی کنید جملات روزمره خود را با این افعال بسازید و در مکالمات روزانه استفاده کنید. تمرین مداوم کلید موفقیت است.', '💡 خاڵ: بۆ فێربوونی باشتری کردارەکانی to be، هەوڵ بدە جملە ڕۆژانەکانت بەم کردارانە دروست بکەیت و لە گفتوگۆی ڕۆژانەدا بەکاربێنیت. ڕاهێنانی بەردەوام کلیلی سەرکەوتنە.', '💡 Tip: To better learn to be verbs, try to construct your daily sentences with these verbs and use them in daily conversations. Consistent practice is the key to success.', 43);
