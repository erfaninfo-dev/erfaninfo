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

// اسلایدر ویدیوهای یوتیوب
window.addEventListener('DOMContentLoaded', function() {
    const slider = document.getElementById('youtube-slider');
    const leftArrow = document.getElementById('youtube-arrow-left');
    const rightArrow = document.getElementById('youtube-arrow-right');
    if (slider && leftArrow && rightArrow) {
        // اسکرول اولیه به انتها (برای RTL)
        slider.scrollLeft = slider.scrollWidth;
        setTimeout(() => {
            slider.scrollLeft = slider.scrollWidth;
        }, 100);
        leftArrow.addEventListener('click', function() {
            slider.scrollBy({ left: 300, behavior: 'smooth' });
        });
        rightArrow.addEventListener('click', function() {
            slider.scrollBy({ left: -300, behavior: 'smooth' });
        });
    }
});