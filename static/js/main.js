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
    const lessonsCard = document.getElementById('lessons-card');
    const videosCard = document.getElementById('videos-card');

    function showUnderConstructionMessage(event) {
        event.preventDefault(); 
        alert("این بخش هنوز در حال ساخت است و به زودی در دسترس خواهد بود!");
    }

    if (lessonsCard) {
        lessonsCard.addEventListener('click', showUnderConstructionMessage);
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
    const modal = document.getElementById('language-modal-overlay');
    const mainContent = document.getElementById('main-content-wrapper');
    const btnFa = document.getElementById('select-fa');
    const btnKu = document.getElementById('select-ku');
    const codeInput = document.getElementById('quiz-code-input');
    const codeError = document.getElementById('code-error-message');
    const submitBtn = document.getElementById('submit-code-btn');

    // Demo dictionary for main page (expand as needed)
    const translations = {
        fa: {
            'navbar-home': 'صفحه اصلی',
            'navbar-grammar': 'تمرین گرامر',
            'navbar-blog': 'وبلاگ',
            'navbar-programming': 'شروع یادگیری برنامه نویسی',
            'navbar-login': 'ورود یا عضویت',
            'main-header-title': 'به سایت آموزشی عرفان اینفو خوش آمدید!',
            'main-header-desc': 'مسیر خود را برای یادگیری زبان انگلیسی انتخاب کنید.',
            'card-grammar-title': 'آزمون گرامر',
            'card-grammar-desc': 'دانش گرامر خود را بیازمایید.',
            'card-lessons-title': 'آموزش گرامر',
            'card-lessons-desc': 'مفاهیم را به زبان ساده یاد بگیرید.',
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
            // ... add more keys as needed
        },
        ku: {
            'navbar-home': 'سەرەتا',
            'navbar-grammar': 'تاقیکردنەوەی گرامەر',
            'navbar-blog': 'بلاگ',
            'navbar-programming': 'دەستپێکردنی فێربوونی بەرنامەنووسین',
            'navbar-login': 'چوونەژوورەوە/تۆماربوون',
            'main-header-title': 'بەخێربێیت بۆ ماڵپەڕی فێرکاری عیرفان ئینفو!',
            'main-header-desc': 'ڕێگای خۆت هەلبژێرە بۆ فێربوونی زمانی ئینگلیزی.',
            'card-grammar-title': 'تاقیکردنەوەی گرامەر',
            'card-grammar-desc': 'زانستی گرامەری خۆت تاقی بکەوە.',
            'card-lessons-title': 'فێرکاری گرامەر',
            'card-lessons-desc': 'وتارەکان بە زمانێکی سادە فێربە.',
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
                } else if (t[key]) {
                    el.textContent = t[key];
                }
            });
            // Quiz buttons (for dynamic content)
            document.querySelectorAll('.start-quiz-btn').forEach(btn => btn.textContent = t['start-quiz']);
            document.querySelectorAll('.expand-card-btn').forEach(btn => btn.textContent = t['view']);
        }
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
    });
    btnKu.addEventListener('click', function() {
        setLanguage('ku');
        localStorage.setItem('langSelected', 'true');
        hideModal();
    });

    if (codeInput && codeError && submitBtn) {
        submitBtn.addEventListener('click', function(e) {
            // Prevent default form submit if inside a form
            if (submitBtn.form) e.preventDefault();
            const code = codeInput.value.trim();
            if (!code) {
                codeError.textContent = (localStorage.getItem('siteLang') === 'ku') ? 'تکایە کۆد بنووسە!' : 'لطفاً کد را وارد کنید!';
            } else if (code !== '1234') { // Demo: only '1234' is valid
                codeError.textContent = (localStorage.getItem('siteLang') === 'ku') ? 'کۆد هەڵەیە!' : 'کد اشتباه است!';
            } else {
                codeError.textContent = '';
                // ... continue with quiz logic ...
            }
        });
    }
});