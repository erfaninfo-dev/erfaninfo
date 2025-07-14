// static/js/main.js

window.addEventListener('load', () => {
    // === بخش ۱: منطق مودال خوش آمدگویی در صفحه اصلی ===
    const overlay = document.getElementById('welcome-overlay');
    const welcomeForm = document.getElementById('welcome-form');
    
    if (overlay && welcomeForm) {
        const firstNameInput = welcomeForm.querySelector('input[name="firstName"]');
        const lastNameInput = welcomeForm.querySelector('input[name="lastName"]');

        if (localStorage.getItem('hasVisited')) {
            overlay.classList.add('hidden');
        } else {
            overlay.classList.remove('hidden');
        }
        
        function hideModal() {
            overlay.classList.add('hidden');
        }

        welcomeForm.addEventListener('submit', (event) => {
            event.preventDefault();
            localStorage.setItem('userFirstName', firstNameInput.value);
            localStorage.setItem('userLastName', lastNameInput.value);
            localStorage.setItem('hasVisited', 'true');
            hideModal();
        });
    }


    // === بخش ۲: منطق کارت‌های "در حال ساخت" در صفحه اصلی ===
    const videosCard = document.getElementById('videos-card');

    function showUnderConstructionMessage(event) {
        event.preventDefault(); 
        alert("این بخش هنوز در حال ساخت است و به زودی در دسترس خواهد بود!");
    }

    if (videosCard) {
        videosCard.addEventListener('click', showUnderConstructionMessage);
    }


    // === بخش ۳: کد اصلاح شده برای منوی همبرگری ===
    const hamburgerBtn = document.getElementById('hamburger-btn');
    const siteHeader = document.getElementById('site-header'); // به کل هدر اشاره می‌کنیم

    if (hamburgerBtn && siteHeader) {
        hamburgerBtn.addEventListener('click', () => {
            // کلاس را به خود تگ header اضافه و کم می‌کنیم
            siteHeader.classList.toggle('nav-open');
        });
    }
});

// === Language Selection Modal Logic ===
document.addEventListener('DOMContentLoaded', function() {
    // تعریف تابع setLanguage و ترجمه‌ها باید همیشه باشد
    const translations = {
        fa: {
            'navbar-home': 'صفحه اصلی',
            'navbar-grammar': 'تمرین گرامر',
            'navbar-results': 'نتایج آزمون‌ها',
            'navbar-blog': 'وبلاگ',
            'navbar-programming': 'شروع یادگیری برنامه نویسی',
            'navbar-login': 'ورود یا عضویت',
            'main-header-title': 'به سایت آموزشی عرفان اینفو خوش آمدید!',
            'main-header-desc': 'مسیر خود را برای یادگیری زبان انگلیسی انتخاب کنید.',
            'name-modal-title': 'نام و نام خانوادگی خود را وارد کنید',
            'name-modal-placeholder': 'نام و نام خانوادگی',
            'card-grammar-title': 'آزمون گرامر',
            'card-grammar-desc': 'دانش گرامر خود را بیازمایید.',
            'card-lessons-title': 'نتایج کاربران',
            'card-lessons-desc': 'آخرین نتایج تمرین های کاربران',
            'card-videos-title': 'ویدیوهای آموزشی',
            'card-videos-desc': 'مهارت‌های خود را ارتقا دهید.',
            'section-title': 'ویدیوهای آموزشی',
            'start-quiz': 'شروع آزمون',
            'view': 'مشاهده',
            'footer-desc': 'سایت آموزشی عرفان اینفو\nیادگیری آسان و حرفه‌ای زبان انگلیسی',
            'tests-title': 'تست‌های گرامر',
            'tests-desc': 'لطفاً یکی از آزمون‌های زیر را برای شروع انتخاب کنید.',
            'student-title': 'زبان آموز',
            'student-placeholder': 'کد تمرین خود را وارد کنید...',
            'student-btn': 'شروع آزمون',
            'full-quiz': 'آزمون کامل (ترکیبی)',
            'start-btn': 'شروع',
            'enter-code-warning': 'لطفاً کد خود را وارد کنید!',
            'not-found': 'سوالی یافت نشد.',
            'report-title': 'گزارش سوال',
            'report-reason-label': 'دلیل گزارش',
            'report-reason-placeholder': 'یک دلیل انتخاب کنید',
            'report-btn': 'ثبت گزارش',
            'report-success': 'گزارش شما با موفقیت ثبت شد.',
            'report-duplicate': 'شما قبلاً این سوال را گزارش داده‌اید.',
            'report-limit': 'تعداد گزارش‌های شما به حد مجاز رسیده است.',
            'report-required': 'لطفاً دلیل گزارش را انتخاب کنید',
            'report-loading': 'در حال ثبت...',
            'report-reason-wrong-question': 'سوال اشتباه است!',
            'report-reason-wrong-answer': 'پاسخ صحیح اشتباه است!',
            'report-reason-multi-answer': 'بیش از یک جواب درست!',
            'report-reason-other': 'سایر',
            // ... add more keys as needed
        },
        ku: {
            'navbar-home': 'سەرەتا',
            'navbar-grammar': 'تاقیکردنەوەی گرامەر',
            'navbar-results': 'ئەنجامەکانی تاقیکردنەوەکان',
            'navbar-blog': 'بلاگ',
            'navbar-programming': 'دەستپێکردنی فێربوونی بەرنامەنووسین',
            'navbar-login': 'چوونەژوورەوە/تۆماربوون',
            'main-header-title': 'بەخێربێیت بۆ ماڵپەڕی فێرکاری عیرفان ئینفو!',
            'main-header-desc': 'ڕێگای خۆت هەلبژێرە بۆ فێربوونی زمانی ئینگلیزی.',
            'name-modal-title': 'ناوی تەواوت بنووسە',
            'name-modal-placeholder': 'ناوی تەواو',
            'card-grammar-title': 'تاقیکردنەوەی گرامەر',
            'card-grammar-desc': 'زانستی گرامەری خۆت تاقی بکەوە.',
            'card-lessons-title': 'ئەنجامەکانی بەکارهێنەران',
            'card-lessons-desc': 'دواترین ئەنجامەکانی ڕاهێنانەکانی بەکارهێنەران',
            'card-videos-title': 'ڤیدیۆی فێرکاری',
            'card-videos-desc': 'تواناکانت بەرز بکەوە.',
            'section-title': 'ڤیدیۆی فێرکاری',
            'start-quiz': 'دەستپێکردن',
            'view': 'بینین',
            'footer-desc': 'ماڵپەڕی فێرکاری عیرفان ئینفو\nفێربوونی ئاسان و پەروەردەی زمانی ئینگلیزی',
            'tests-title': 'تاقیکردنەوەکانی گرامەر',
            'tests-desc': 'تکایە یەکێک لە تاقیکردنەوەکان هەلبژێرە بۆ دەستپێکردن.',
            'student-title': 'خوێندکار',
            'student-placeholder': 'کۆدی تاقیکردنەوە بنووسە...',
            'student-btn': 'دەستپێکردن',
            'full-quiz': 'هەموو (تێکەڵ)',
            'start-btn': 'دەستپێکردن',
            'enter-code-warning': 'تکایە کۆدی خۆت بنووسە!',
            'not-found': 'هیچ پرسیارێک نەدۆزرایەوە.',
            'report-title': 'ڕاپۆرتکردنی پرسیار',
            'report-reason-label': 'هۆکاری ڕاپۆرتکردن',
            'report-reason-placeholder': 'هۆکارت هەلبژێرە',
            'report-btn': 'ناردنی ڕاپۆرت',
            'report-success': 'ڕاپۆرتەکەت بەسەرکەوتوویی تۆمار کرا.',
            'report-duplicate': 'پێشتر ئەم پرسیارەی ڕاپۆرت کردووە.',
            'report-limit': 'ژمارەی ڕاپۆرتەکانت گەیشتوە بەرزترین سنوور.',
            'report-required': 'تکایە هۆکاری ڕاپۆرتکردن هەلبژێرە',
            'report-loading': 'لە ناردن...',
            'report-reason-wrong-question': 'پرسیارەکە هەڵەیە!',
            'report-reason-wrong-answer': 'وەڵامی ڕاست هەڵەیە!',
            'report-reason-multi-answer': 'زیاتر لە یەک وەڵامی ڕاست هەیە!',
            'report-reason-other': 'هەر هۆکارێکی تر',
            // ... add more keys as needed
        }
    };
    function setLanguage(lang) {
        localStorage.setItem('siteLang', lang);
        const t = translations[lang];
        if (t) {
            document.querySelectorAll('[data-key]').forEach(el => {
                const key = el.getAttribute('data-key');
                if (key === 'student-placeholder' && el.tagName === 'INPUT') {
                    el.setAttribute('placeholder', t[key]);
                } else if (key === 'name-modal-placeholder' && el.tagName === 'INPUT') {
                    el.setAttribute('placeholder', t[key]);
                } else if (t[key]) {
                    el.textContent = t[key];
                }
            });
            // Quiz buttons (for dynamic content)
            document.querySelectorAll('.start-quiz-btn').forEach(btn => btn.textContent = t['start-quiz']);
            document.querySelectorAll('.expand-card-btn').forEach(btn => btn.textContent = t['view']);
            // دکمه شروع در مودال نام
            document.querySelectorAll('[data-key="start-btn"]').forEach(btn => btn.textContent = t['start-btn']);
            // اخطار وارد کردن کد
            document.querySelectorAll('[data-key="enter-code-warning"]').forEach(el => el.textContent = t['enter-code-warning']);
            document.querySelectorAll('[data-key="not-found"]').forEach(el => el.textContent = t['not-found']);

            // ترجمه گزینه‌های لیست دلیل گزارش
            const reasonOptions = [
              { key: 'report-reason-placeholder', selector: '#report-reason option[value=""]' },
              { key: 'report-reason-wrong-question', selector: '#report-reason option[value="سوال اشتباه"]' },
              { key: 'report-reason-wrong-answer', selector: '#report-reason option[value="پاسخ اشتباه"]' },
              { key: 'report-reason-multi-answer', selector: '#report-reason option[value="بیش از یک جواب درست"]' },
              { key: 'report-reason-other', selector: '#report-reason option[value="سایر"]' }
            ];
            reasonOptions.forEach(opt => {
              const el = document.querySelector(opt.selector);
              if (el && t[opt.key]) el.textContent = t[opt.key];
            });
        }
    }
    // دکمه‌های هدر همیشه باید کار کنند
    var btnFaHeader = document.getElementById('btn-fa-header');
    var btnKuHeader = document.getElementById('btn-ku-header');
    if (btnFaHeader) {
        btnFaHeader.onclick = function() { setLanguage('fa'); };
    }
    if (btnKuHeader) {
        btnKuHeader.onclick = function() { setLanguage('ku'); };
    }
    // حالا شرط langSelected فقط برای منطق مودال باشد
    const modal = document.getElementById('language-modal-overlay');
    const mainContent = document.getElementById('main-content-wrapper');
    const btnFa = document.getElementById('select-fa');
    const btnKu = document.getElementById('select-ku');
    const codeInput = document.getElementById('quiz-code-input');
    const codeError = document.getElementById('code-error-message');
    const submitBtn = document.getElementById('submit-code-btn');

    if (localStorage.getItem('langSelected')) {
        document.getElementById('language-modal-overlay').style.display = 'none';
        document.getElementById('main-content-wrapper').classList.add('no-blur');
        setLanguage(localStorage.getItem('siteLang') || 'fa');
        return;
    }

    function hideModal() {
        modal.style.display = 'none';
        mainContent.classList.add('no-blur');
    }

    // Only show language modal on very first visit to the home page
    const isHomePage = window.location.pathname === '/' || window.location.pathname === '/home' || window.location.pathname === '/home_new';
    if (!localStorage.getItem('langSelected')) {
        if (isHomePage) {
            modal.style.display = 'flex';
            mainContent.classList.remove('no-blur');
        } else {
            // Not home, but no language selected: fallback to fa
            setLanguage('fa');
            hideModal();
        }
    } else {
        setLanguage(localStorage.getItem('siteLang') || 'fa');
        hideModal();
    }

    btnFa.addEventListener('click', function() {
        setLanguage('fa');
        localStorage.setItem('langSelected', 'true');
        hideModal();
        location.reload(); // رفرش صفحه بعد از انتخاب زبان
    });
    btnKu.addEventListener('click', function() {
        setLanguage('ku');
        localStorage.setItem('langSelected', 'true');
        hideModal();
        location.reload(); // رفرش صفحه بعد از انتخاب زبان
    });

    if (codeInput && codeError && submitBtn) {
        submitBtn.addEventListener('click', function(e) {
            // Prevent default form submit if inside a form
            if (submitBtn.form) e.preventDefault();
            const code = codeInput.value.trim();
            if (!code) {
                codeError.textContent = translations[localStorage.getItem('siteLang') || 'fa']['enter-code-warning'];
            } else if (code !== '1234') { // Demo: only '1234' is valid
                codeError.textContent = (localStorage.getItem('siteLang') === 'ku') ? 'کۆد هەڵەیە!' : 'کد اشتباه است!';
            } else {
                codeError.textContent = '';
                // ... continue with quiz logic ...
            }
        });
    }
});