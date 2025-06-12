// static/js/tests_animations.js

document.addEventListener('DOMContentLoaded', () => {
    const quizCardContainer = document.querySelector('.quiz-card-container');
    const allCards = document.querySelectorAll('.quiz-card');

    // خواندن ارتفاع اولیه کارت‌ها از استایل‌های محاسبه‌شده توسط مرورگر
    const initialCardHeight = allCards.length > 0 ? getComputedStyle(allCards[0]).height : '220px';

    allCards.forEach(card => {
        const expandButton = card.querySelector('.expand-card-btn');
        const hiddenDetails = card.querySelector('.hidden-details');
        const quizCardHeader = card.querySelector('.quiz-card-header');

        // این منطق فقط برای کارت‌هایی اجرا می‌شود که دکمه "مشاهده" دارند
        if (!card.dataset.hasSubOptions || card.dataset.hasSubOptions === 'false' || !expandButton || !hiddenDetails) {
            return;
        }
        
        // تابع کمکی برای بستن یک کارت مشخص
        const closeCard = (cardToClose) => {
            const details = cardToClose.querySelector('.hidden-details');
            const button = cardToClose.querySelector('.expand-card-btn');

            cardToClose.classList.remove('expanded');
            if (details) {
                details.style.height = '0';
                details.style.opacity = '0';
                details.style.pointerEvents = 'none';
            }
            if (button) {
                button.style.opacity = '1';
                button.style.pointerEvents = 'auto';
            }
            // بازگشت به ارتفاع اولیه تعریف شده در CSS
            cardToClose.style.height = initialCardHeight;
            cardToClose.style.minHeight = initialCardHeight;
        };
        
        // افزودن رویداد کلیک به دکمه "مشاهده"
        expandButton.addEventListener('click', (event) => {
            event.stopPropagation();

            const isAlreadyExpanded = card.classList.contains('expanded');

            // ابتدا، هر کارت دیگری که باز است را ببند
            const currentlyExpandedCard = document.querySelector('.quiz-card.expanded');
            if (currentlyExpandedCard && currentlyExpandedCard !== card) {
                closeCard(currentlyExpandedCard);
            }
            
            // اگر کارتی که روی آن کلیک شده باز بود، آن را ببند
            if (isAlreadyExpanded) {
                closeCard(card);
                quizCardContainer.classList.remove('blurred');
            } else {
                // در غیر این صورت، کارت جدید را باز کن
                card.classList.add('expanded');
                quizCardContainer.classList.add('blurred');

                hiddenDetails.style.height = 'auto'; // تنظیم موقت برای محاسبه ارتفاع واقعی محتوای پنهان
                
                // === محاسبه دقیق و دینامیک ارتفاع نهایی ===
                const headerHeight = quizCardHeader.offsetHeight;
                const detailsHeight = hiddenDetails.scrollHeight;
                const requiredCardHeight = headerHeight + detailsHeight + 40; // 40px برای padding

                hiddenDetails.style.height = '0'; // بازگشت به صفر برای شروع انیمیشن
                void hiddenDetails.offsetWidth; // یک ترفند برای اطمینان از اجرای انیمیشن

                // اعمال ارتفاع‌های محاسبه‌شده برای اجرای انیمیشن روان
                card.style.height = `${requiredCardHeight}px`;
                card.style.minHeight = `${requiredCardHeight}px`;
                hiddenDetails.style.height = `${detailsHeight}px`;
                hiddenDetails.style.opacity = '1';
                hiddenDetails.style.pointerEvents = 'auto';
                expandButton.style.opacity = '0';
                expandButton.style.pointerEvents = 'none';

                // اسکرول به سمت کارت باز شده برای دید بهتر
                setTimeout(() => {
                    card.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 300);
            }
        });
    });

    // رویداد کلیک روی صفحه برای بستن کارت باز در صورت کلیک در خارج از آن
    document.addEventListener('click', (event) => {
        const expandedCard = document.querySelector('.quiz-card.expanded');
        // اگر یک کارت باز وجود دارد و کلیک خارج از آن بوده است
        if (expandedCard && !expandedCard.contains(event.target)) {
            const cardToClose = expandedCard;
            const details = cardToClose.querySelector('.hidden-details');
            const button = cardToClose.querySelector('.expand-card-btn');

            quizCardContainer.classList.remove('blurred');
            cardToClose.classList.remove('expanded');
            
            if (details) {
                details.style.height = '0';
                details.style.opacity = '0';
                details.style.pointerEvents = 'none';
            }
            if (button) {
                button.style.opacity = '1';
                button.style.pointerEvents = 'auto';
            }
            // بازگرداندن کارت به ارتفاع اولیه
            cardToClose.style.height = initialCardHeight;
            cardToClose.style.minHeight = initialCardHeight;
        }
    });
});