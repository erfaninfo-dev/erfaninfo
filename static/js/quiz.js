// static/js/quiz.js

let score = 0;
let currentQuestionIndex = 0;
let isAnswered = false;

// متغیر سراسری questions.
// این متغیر حالا از 'window.initialQuizQuestions' مقداردهی اولیه می‌شود که توسط Flask تنظیم شده است.
// اگر 'window.initialQuizQuestions' وجود نداشته باشد (مثلا برای آزمون های شخصی سازی شده)،
// آن را به یک آرایه خالی مقداردهی می کنیم.
let questions = window.initialQuizQuestions || [];

// نگهداری وضعیت آزمون ترکیبی و لیست گرامرهای انتخاب‌شده در طول جلسه
let isCombinedTestSession = false;
let combinedSelectedGrammars = [];
let combinedOrderMode = 'grammar'; // 'grammar' | 'random'

let personalQuizCode = null;

// متغیرهای تایمر
let timer = null;
let timeLeft = 60; // 60 ثانیه = 1 دقیقه

// امکان جایگزینی رفتار دکمه Next برای انواع خاص (matching/gapfill)
let customCheckHandler = null;


let currentQuizTitle = document.title.replace('آزمون: ', ''); // عنوان اولیه از Flask

// ثبت جزئیات هر سوال برای صفحه جزئیات نتایج
const resultItems = [];


// === بخش جدید: بارگذاری سوالات شخصی سازی شده از localStorage ===
const storedQuestions = localStorage.getItem('currentQuizQuestions');
const storedTitle = localStorage.getItem('currentQuizTitle');
const storedCode = localStorage.getItem('currentQuizCode');

if (storedQuestions && storedTitle && storedCode) {
    personalQuizCode = storedCode; // کد آزمون شخصی را نگه دار
    questions = JSON.parse(storedQuestions); // متغیر questions را با سوالات شخصی جایگزین می‌کند.
    currentQuizTitle = storedTitle; // عنوان را با عنوان شخصی جایگزین می‌کند.
    document.title = `آزمون: ${currentQuizTitle}`; // عنوان تب مرورگر را به‌روزرسانی می‌کند.

    // بلافاصله پس از استفاده، اطلاعات را از localStorage پاک می‌کنیم.
    localStorage.removeItem('currentQuizQuestions');
    localStorage.removeItem('currentQuizTitle');
    // کد آزمون را بعد از ثبت نتیجه پاک می‌کنیم
}

// === بخش جدید: بارگذاری سوالات آزمون ترکیبی از sessionStorage (فقط وقتی در /test/combined هستیم) ===
const isCombinedRoute = /\/test\/combined\/?$/.test(window.location.pathname);
const combinedTestData = isCombinedRoute ? sessionStorage.getItem('combinedTestData') : null;
if (isCombinedRoute && combinedTestData) {
    const data = JSON.parse(combinedTestData);
    questions = data.questions;
    // عنوان آزمون ترکیبی باید همیشه ثابت باشد
    currentQuizTitle = 'آزمون ترکیبی';
    document.title = `آزمون: ${currentQuizTitle}`;

    // علامت‌گذاری اینکه این یک جلسه‌ی آزمون ترکیبی است و نگهداری گرامرها به‌صورت سراسری
    isCombinedTestSession = true;
    if (Array.isArray(data.selectedGrammars)) {
        combinedSelectedGrammars = data.selectedGrammars.slice();
    }
    if (data.orderMode) {
        combinedOrderMode = data.orderMode;
    }

    // اگر حالت شانسی باشد، در کلاینت هم یک بار شافل می‌کنیم تا کاملاً تصادفی شود
    if (combinedOrderMode === 'random' && Array.isArray(questions)) {
        for (let i = questions.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [questions[i], questions[j]] = [questions[j], questions[i]];
        }
    }

    // توجه: داده‌ها را از sessionStorage حذف نمی‌کنیم تا در زمان ذخیره نتیجه نیز در دسترس باشند
} else {
    // در سایر مسیرها (آزمون تکی یا آزمون شخصی) مطمئن شو اثر آزمون ترکیبی باقی نمانده باشد
    try { sessionStorage.removeItem('combinedTestData'); } catch (e) {}
}
// =========================================================


// گرفتن عناصر HTML
const questionTextEl = document.getElementById('question-text');
const optionsGridEl = document.getElementById('options-grid');
const checkBtnEl = document.getElementById('check-btn');
const progressBarInnerEl = document.getElementById('progress-bar-inner');
const quizMainViewEl = document.getElementById('quiz-main-view');
const resultsEl = document.getElementById('quiz-results');
const resultsTextEl = document.getElementById('results-text');
const restartBtnEl = document.getElementById('restart-btn');
const resultsGreetingEl = document = document.getElementById('results-greeting');
const closeQuizBtnEl = document.getElementById('close-quiz-btn');
const confirmModalOverlayEl = document.getElementById('confirm-modal-overlay');
const confirmYesBtnEl = document.getElementById('confirm-yes-btn');
const confirmNoBtnEl = document.getElementById('confirm-no-btn');
const returnToListBtnEl = document.getElementById('return-to-list-btn');

// اضافه شدن عنصر جدید برای شمارنده سوال
const questionCounterEl = document.getElementById('question-counter');

// اضافه شدن عنصر دکمه گزارش
const reportQuestionBtnEl = document.getElementById('report-question-btn');

// اضافه شدن عناصر مربوط به توضیحات آموزشی
const explanationBtnEl = document.getElementById('explanation-btn');
const explanationModalOverlayEl = document.getElementById('explanation-modal-overlay');
const explanationContentEl = document.getElementById('explanation-content');
const explanationOkBtnEl = document.getElementById('explanation-ok-btn');

// عناصر تایمر
const timerMinutesEl = document.getElementById('timer-minutes');
const timerSecondsEl = document.getElementById('timer-seconds');
const timerEl = document.querySelector('.timer');
const timeUpMessageEl = document.getElementById('time-up-message');

// قفل کردن تعاملات مچینگ وقتی زمان تمام شود
let matchingLocked = false;

function disableMatchingUI() {
    try {
        matchingLocked = true;
        const matchBtns = document.querySelectorAll('.match-btn');
        matchBtns.forEach(btn => {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.cursor = 'not-allowed';
        });
    } catch (e) {}
}

// === Name Modal Logic ===
const nameModalOverlay = document.getElementById('name-modal-overlay');
const fullnameInput = document.getElementById('fullname-input');
const fullnameError = document.getElementById('fullname-error');
const startQuizBtn = document.getElementById('start-quiz-btn');

function showNameModal() {
    nameModalOverlay.classList.remove('hidden');
    fullnameInput.value = '';
    fullnameError.textContent = '';
    fullnameInput.focus();
}

function hideNameModal() {
    nameModalOverlay.classList.add('hidden');
}

// Remove the overlay click handler for name modal to prevent closing by clicking outside
// nameModalOverlay.addEventListener('click', function(e) {
//     if (e.target === nameModalOverlay) {
//         hideNameModal();
//     }
// });

function getFullName() {
    return localStorage.getItem('userFullName');
}

function setFullName(name) {
    localStorage.setItem('userFullName', name);
}

// توابع تایمر
function startTimer() {
    timeLeft = 60; // ریست کردن تایمر
    updateTimerDisplay();
    
    timer = setInterval(() => {
        timeLeft--;
        updateTimerDisplay();
        
        // تغییر رنگ تایمر بر اساس زمان باقی‌مانده
        if (timeLeft <= 10) {
            timerEl.classList.remove('warning');
            timerEl.classList.add('danger');
        } else if (timeLeft <= 30) {
            timerEl.classList.remove('danger');
            timerEl.classList.add('warning');
        }
        
        if (timeLeft <= 0) {
            clearInterval(timer);
            timeUp();
        }
    }, 1000);
}

function updateTimerDisplay() {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;
    
    if (timerMinutesEl) timerMinutesEl.textContent = minutes.toString().padStart(2, '0');
    if (timerSecondsEl) timerSecondsEl.textContent = seconds.toString().padStart(2, '0');
}

function stopTimer() {
    if (timer) {
        clearInterval(timer);
        timer = null;
    }
}

function timeUp() {
    // غیرفعال کردن گزینه‌ها
    const optionButtons = document.querySelectorAll('.option-btn');
    optionButtons.forEach(btn => {
        btn.disabled = true;
        btn.style.opacity = '0.5';
    });
    // غیرفعال کردن مچینگ
    disableMatchingUI();

    // اگر سوال از نوع جای خالی است، مثل حالت جواب غلط رفتار کند:
    try {
        const input = document.getElementById('gapfill-input');
        if (input) {
            input.classList.remove('gap-correct');
            input.classList.add('gap-incorrect');
            input.disabled = true;
            const currentQuestion = questions[currentQuestionIndex] || {};
            const correct = (currentQuestion.gap_answer || '').trim();
            // ساخت/نمایش بنر مشابه حالت Incorrect
            let statusBanner = document.getElementById('gap-status-banner');
            if (!statusBanner) {
                statusBanner = document.createElement('div');
                statusBanner.id = 'gap-status-banner';
                statusBanner.className = 'gap-status-banner';
                const ref = document.querySelector('.options-grid');
                if (ref) ref.insertAdjacentElement('afterend', statusBanner);
            }
            statusBanner.innerHTML = `<div class="gap-banner-answer ltr">Correct Answer: <span class="gap-correct-text">${correct}</span></div>`;
            statusBanner.classList.remove('hidden');
            if (checkBtnEl) checkBtnEl.classList.add('error');
        }
    } catch(_) {}
    
    // فعال کردن دکمه Next
    if (checkBtnEl) {
        checkBtnEl.disabled = false;
        checkBtnEl.textContent = 'Next';
        // روی Next در حالت timeUp مستقیماً به سوال بعد برو
        customCheckHandler = () => { proceedNext(); };
    }
    
    // نمایش پیام زمان تمام شده
    if (timeUpMessageEl) {
        timeUpMessageEl.style.display = 'block';
    }
    
    // فعال کردن دکمه توضیحات (ایموجی مغز) اگر هر توضیحی موجود باشد
    const currentQuestion = questions[currentQuestionIndex];
    if (currentQuestion) {
        const lang = localStorage.getItem('siteLang') || 'fa';
        const faHas = currentQuestion.fa_explanation && currentQuestion.fa_explanation.trim() !== '';
        const kuHas = currentQuestion.kur_explanation && currentQuestion.kur_explanation.trim() !== '';
        const enHas = currentQuestion.eng_explanation && currentQuestion.eng_explanation.trim() !== '';
        const hasExplanation = faHas || kuHas || enHas;
        if (hasExplanation && explanationBtnEl) {
            explanationBtnEl.style.display = 'inline-block';
            explanationBtnEl.disabled = false;
        }
    }
}

// Only show modal if name not set
if (!getFullName()) {
    showNameModal();
    // Prevent quiz interaction until name is set
    if (quizMainViewEl) quizMainViewEl.style.pointerEvents = 'none';
}

startQuizBtn && startQuizBtn.addEventListener('click', function() {
    const name = fullnameInput.value.trim();
    if (!name) {
        fullnameError.textContent = 'لطفاً نام و نام خانوادگی را وارد کنید!';
        fullnameInput.focus();
        return;
    }
    setFullName(name);
    hideNameModal();
    if (quizMainViewEl) quizMainViewEl.style.pointerEvents = '';
});

// Optional: If you want to allow Enter key to submit
fullnameInput && fullnameInput.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        startQuizBtn.click();
    }
});

// --- توابع loadQuestion و selectOption (بدون تغییر در منطق اصلی) ---
function clearOptions() {
    optionsGridEl.innerHTML = '';
    optionsGridEl.classList.remove('match-host');
    // خروج از حالت فشرده مچینگ وقتی سوال نوع دیگری است
    const qc = document.querySelector('.quiz-container');
    if (qc) qc.classList.remove('matching-compact');
}

// شافل آرایه (Fisher-Yates)
function shuffleArray(arr) {
    if (!Array.isArray(arr)) return arr;
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

// Highlight helper for words "incorrect" / "incorrectly" inside question text
let incorrectHighlightStylesInjected = false;
function ensureIncorrectHighlightStyles() {
    if (incorrectHighlightStylesInjected) return;
    const style = document.createElement('style');
    style.id = 'incorrect-highlight-styles';
    style.textContent = `.hi-incorrect{ color:#dc2626 !important; }`;
    document.head.appendChild(style);
    incorrectHighlightStylesInjected = true;
}

function highlightIncorrectInElement(rootEl) {
    if (!rootEl) return;
    ensureIncorrectHighlightStyles();
    const walker = document.createTreeWalker(rootEl, NodeFilter.SHOW_TEXT, null);
    const textNodes = [];
    while (walker.nextNode()) textNodes.push(walker.currentNode);
    const regex = /\b(incorrect|incorrectly)\b/gi;
    textNodes.forEach(node => {
        const text = node.nodeValue;
        if (!regex.test(text)) return;
        const frag = document.createDocumentFragment();
        let lastIndex = 0;
        text.replace(regex, (match, _g1, offset) => {
            if (offset > lastIndex) frag.appendChild(document.createTextNode(text.slice(lastIndex, offset)));
            const span = document.createElement('span');
            span.className = 'hi-incorrect';
            span.textContent = match;
            frag.appendChild(span);
            lastIndex = offset + match.length;
            return match;
        });
        if (lastIndex < text.length) frag.appendChild(document.createTextNode(text.slice(lastIndex)));
        if (node.parentNode) node.parentNode.replaceChild(frag, node);
    });
}

// زیرخط‌گذاری کلمات برای ترجمه سریع
function decorateTranslatableWords(rootEl){
    if (!rootEl) return;
    // از داخل تگ‌های موجود (به جز ورودی) فقط متن‌ها را به span.tword تبدیل کن
    const walker = document.createTreeWalker(rootEl, NodeFilter.SHOW_TEXT, null);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);
    nodes.forEach(node => {
        const text = (node.nodeValue || '').replace(/\s+/g,' ');
        if (!text.trim()) return;
        
        // بررسی اینکه آیا این متن داخل پرانتز است یا نه
        const parentElement = node.parentElement;
        const isInsideParentheses = parentElement && parentElement.classList.contains('tr-word');
        
        if (isInsideParentheses) {
            // اگر داخل پرانتز است، کل متن را به عنوان یک واحد در نظر بگیر
            const span = document.createElement('span');
            span.className = 'tword';
            span.textContent = text;
            span.setAttribute('data-word', text);
            if (node.parentNode) node.parentNode.replaceChild(span, node);
        } else {
            // اگر خارج از پرانتز است، کلمات را جداگانه تبدیل کن
            const parts = text.split(/(\s+)/);
            const frag = document.createDocumentFragment();
            parts.forEach(part => {
                if (/^\s+$/.test(part)) { frag.appendChild(document.createTextNode(part)); return; }
                const span = document.createElement('span');
                span.className = 'tword';
                span.textContent = part;
                span.setAttribute('data-word', part);
                frag.appendChild(span);
            });
            if (node.parentNode) node.parentNode.replaceChild(frag, node);
        }
    });
    // هندلر کلیک را متصل کن
    attachTranslateHandlers(rootEl);
}

function renderMultipleChoice(currentQuestion) {
    questionTextEl.textContent = currentQuestion.text;
    highlightIncorrectInElement(questionTextEl);
    decorateTranslatableWords(questionTextEl);
    appendSentenceTranslateEmoji(String(currentQuestion.text || ''));
    clearOptions();
    (currentQuestion.options || []).forEach(option => {
        const button = document.createElement('button');
        button.textContent = option;
        button.classList.add('option-btn');
        button.addEventListener('click', () => selectOption(button, currentQuestion));
        optionsGridEl.appendChild(button);
    });
}

function renderGapFill(currentQuestion) {
    // Render a single input for now (simple gapfill). Can be extended to multiple blanks later.
    clearOptions();
    ensureGapfillStylesInjected();
    const rawText = String(currentQuestion.text || '');
    // First-letter assist: prefill the first character of the correct answer and keep it fixed
    const correctAnswerRaw = String((currentQuestion.gap_answer || currentQuestion.answer || currentQuestion.correct_answer || '')).trim();
    const fixedPrefix = correctAnswerRaw ? correctAnswerRaw.charAt(0) : '';
    // جایگزینی [[1]] یا چند خط underscore با یک input درون‌خطی (کوچک و بدون گوشه گرد)
    // افزودن ایموجی ترجمه برای واژه‌های داخل پرانتز: (word)
    // روی ایموجی کلیک شود، ترجمه فارسی در پاپاور کوچک نشان داده می‌شود
    const withTranslateEmoji = rawText.replace(/\(([^()]+)\)/g, (m, w) => {
        const safe = String(w).trim();
        if (!safe) return m;
        return `<span class="tr-group"><span class="tr-paren">(</span><span class="tr-word attn" data-word="${safe}">${safe}</span><span class="tr-paren">)</span></span>`;
    });
    const replaced = withTranslateEmoji.replace(/\[\[\s*1\s*\]\]|_{3,}/g, '<span class="gap-inline-wrap"><input type="text" id="gapfill-input" class="gap-inline" autocomplete="off" maxlength="20" /></span>');
    questionTextEl.innerHTML = replaced;
    highlightIncorrectInElement(questionTextEl);
    decorateTranslatableWords(questionTextEl);
    appendSentenceTranslateEmoji(String(currentQuestion.text || ''));
    let input = document.getElementById('gapfill-input');
    if (!input) {
        // اگر الگو پیدا نشد، به حالت تکست‌باکس زیر سوال برگردیم
        questionTextEl.textContent = rawText;
        input = document.createElement('input');
        input.type = 'text';
        input.className = 'gap-input';
        const wrapper = document.createElement('div');
        wrapper.className = 'gap-wrapper';
        wrapper.appendChild(input);
        optionsGridEl.appendChild(wrapper);
    }
    // برای ورودی درون‌خطی، placeholder طول را زیاد می‌کند؛ خالی می‌گذاریم
    input.placeholder = '';
    // اندازه ورودی: دقیقاً برابر پهنای واقعی پاسخ صحیح (px) و با تایپ بیشتر بزرگ‌تر شود (بدون مخفی شدن حروف)
    const measurer = document.createElement('span');
    measurer.style.cssText = 'position:absolute;visibility:hidden;white-space:pre;pointer-events:none;left:-9999px;top:-9999px;';
    document.body.appendChild(measurer);
    const syncMeasureFont = () => {
        const cs = window.getComputedStyle(input);
        measurer.style.fontFamily = cs.fontFamily;
        measurer.style.fontSize = cs.fontSize;
        measurer.style.fontWeight = cs.fontWeight;
        measurer.style.fontStyle = cs.fontStyle;
        measurer.style.letterSpacing = cs.letterSpacing;
    };
    const measurePx = (text) => {
        syncMeasureFont();
        measurer.textContent = text && text.length ? text : ' ';
        return Math.ceil(measurer.getBoundingClientRect().width);
    };
    const baseWidthPx = Math.max(1, measurePx(correctAnswerRaw));
    const autoSize = () => {
        const currPx = measurePx(input.value);
        const paddingComp = 14; // جبران پدینگ/بوردر و تفاوت اندازه‌گیری
        const w = Math.max(baseWidthPx, currPx) + paddingComp;
        input.style.width = w + 'px';
        input.style.minWidth = (baseWidthPx + paddingComp) + 'px';
        input.style.maxWidth = '100%';
        input.style.whiteSpace = 'nowrap';
        input.style.overflow = 'visible';
        input.style.boxSizing = 'content-box';
    };
    // Prefill first letter and set caret after it
    if (fixedPrefix) {
        // درج کاراکتر ثابت در ابتدای فیلد با LTR تا کرسر چسبیده به راست حرف نمایش داده نشود
        input.value = fixedPrefix;
        input.dir = 'ltr';
        input.style.direction = 'ltr';
        input.style.textAlign = 'left';
        // selectionRange will also be enforced after focus
        try { input.setSelectionRange(1,1); } catch(_){}
    }
    // اندازه اولیه دقیقاً برابر پهنای پاسخ صحیح (px)
    input.style.width = (baseWidthPx + 14) + 'px';
    input.style.minWidth = (baseWidthPx + 14) + 'px';
    input.style.boxSizing = 'content-box';
    autoSize();
    input.addEventListener('input', () => {
        // Prevent removing the fixed first letter
        if (fixedPrefix && !input.value.startsWith(fixedPrefix)) {
            const rest = input.value.replace(/^./, '');
            input.value = fixedPrefix + rest;
        }
        // Ensure caret never moves before index 1 و اسکرول سمت راست برای عدم پنهان شدن کاراکترهای ابتدایی
        if (fixedPrefix) {
            try { if (input.selectionStart < 1) input.setSelectionRange(1,1); } catch(_){}
            try { input.scrollLeft = input.scrollWidth; } catch(_){}
        }
        checkBtnEl.disabled = input.value.trim().length <= (fixedPrefix ? 1 : 0);
        autoSize();
    });
    input.addEventListener('keydown', (e) => {
        // Block deleting or moving before the fixed first letter
        if (fixedPrefix) {
            const atStart = (input.selectionStart || 0) <= 1 && (input.selectionEnd || 0) <= 1;
            if (e.key === 'Backspace' && atStart) { e.preventDefault(); return; }
            if (e.key === 'ArrowLeft' && atStart) { e.preventDefault(); try { input.setSelectionRange(1,1); } catch(_){} return; }
            // نگه داشتن caret در انتهای متن هنگام تایپ‌های طولانی تا متن سمت چپ مخفی نشود
            setTimeout(() => { try { input.scrollLeft = input.scrollWidth; } catch(_){} }, 0);
        }
        if (e.key === 'Enter' && !checkBtnEl.disabled) {
            e.preventDefault();
            if (typeof customCheckHandler === 'function') customCheckHandler();
        }
    });
    // Create/Reset status banner above Next button (sibling after options grid)
    const oldBanner = document.getElementById('gap-status-banner');
    if (oldBanner && oldBanner.parentNode) oldBanner.parentNode.removeChild(oldBanner);
    const statusBanner = document.createElement('div');
    statusBanner.id = 'gap-status-banner';
    statusBanner.className = 'gap-status-banner hidden';
    optionsGridEl.insertAdjacentElement('afterend', statusBanner);

    // Focus input and ensure caret stays after the first fixed letter
    setTimeout(() => { 
        try { 
            input.focus(); 
            if (fixedPrefix) {
                input.setSelectionRange(1,1);
            }
        } catch(_){}
    }, 0);

    // ترجمه آنی با کلیک روی ایموجی 🌐
    attachTranslateHandlers(questionTextEl);

    // Override select flow: when pressing Next, evaluate text
    checkBtnEl.textContent = 'CHECK';
    checkBtnEl.disabled = true;
    let gapEvaluated = false;
    const feedback = document.createElement('div');
    feedback.className = 'gap-feedback';
    // جایی برای نمایش بازخورد: اگر wrapper وجود دارد به آن اضافه کن، وگرنه بعد از input درج کن
    if (input.closest('.gap-wrapper')) {
        input.closest('.gap-wrapper').appendChild(feedback);
    } else {
        input.insertAdjacentElement('afterend', feedback);
    }

    const runEvaluation = () => {
        if (gapEvaluated) return;
        isAnswered = true;
        stopTimer();
        const user = (input.value || '').trim();
        const correct = (currentQuestion.gap_answer || '').trim();
        const isCorrect = normalizeAnswer(user) === normalizeAnswer(correct);
        input.classList.remove('gap-incorrect','gap-correct');
        if (isCorrect) {
            input.classList.add('gap-correct');
            // Hide banner, ensure button not in error state
            statusBanner.classList.add('hidden');
            statusBanner.innerHTML = '';
            checkBtnEl.classList.remove('error');
            feedback.textContent = '';
            score++;
        } else {
            input.classList.add('gap-incorrect');
            // Show red banner with Incorrect and correct answer
            statusBanner.innerHTML = `<div class="gap-banner-title ltr">✖ Incorrect</div><div class="gap-banner-answer ltr">Correct Answer: <span class="gap-correct-text">${correct}</span></div>`;
            statusBanner.classList.remove('hidden');
            // Color the NEXT button red but keep its label
            checkBtnEl.classList.add('error');
            feedback.textContent = '';
            // Enable explanation emoji if explanation exists
            try {
                const lang = localStorage.getItem('siteLang') || 'fa';
                const faHas = currentQuestion.fa_explanation && currentQuestion.fa_explanation.trim() !== '';
                const kuHas = currentQuestion.kur_explanation && currentQuestion.kur_explanation.trim() !== '';
                const enHas = currentQuestion.eng_explanation && currentQuestion.eng_explanation.trim() !== '';
                const hasExplanation = faHas || kuHas || enHas;
                if (hasExplanation && explanationBtnEl) {
                    explanationBtnEl.style.display = 'inline-block';
                    explanationBtnEl.disabled = false;
                }
            } catch (e) {}
        }
        // ثبت آیتم نتیجه
        try {
            resultItems.push({
                id: currentQuestion.id,
                type: 'gapfill',
                text: currentQuestion.text,
                options: { gap_answer: currentQuestion.gap_answer },
                user_answer: user,
                answer: correct,
                is_correct: isCorrect,
                fa_explanation: currentQuestion.fa_explanation || '',
                kur_explanation: currentQuestion.kur_explanation || '',
                eng_explanation: currentQuestion.eng_explanation || ''
            });
        } catch(_) {}
        gapEvaluated = true;
        checkBtnEl.textContent = 'NEXT';
        checkBtnEl.disabled = false;
        customCheckHandler = () => { proceedNext(); };
    };

    customCheckHandler = () => {
        if (!gapEvaluated) runEvaluation(); else proceedNext();
    };
}

function renderMatching(currentQuestion) {
    questionTextEl.textContent = currentQuestion.text;
    decorateTranslatableWords(questionTextEl);
    highlightIncorrectInElement(questionTextEl);
    clearOptions();
    // ورود به حالت فشرده برای نمایش کامل باکس کویز
    const qc = document.querySelector('.quiz-container');
    if (qc) qc.classList.add('matching-compact');
    // تیتر را زیر تایمر کاملاً بچسبان
    const prompt = document.querySelector('.question-prompt');
    if (prompt) {
        prompt.style.paddingTop = '6px';
        prompt.style.marginTop = '6px';
    }
    matchingLocked = false;

    const pairs = Array.isArray(currentQuestion.pairs) ? currentQuestion.pairs.slice() : [];
    // بر اساس بازخورد، ستون چپ باید مقادیر right_item را نشان ندهد.
    // اینجا چپ = left_item و راست = right_item را تضمین می‌کنیم.
    const left = pairs.map((p, idx) => ({ idx, text: p.left }));
    const right = pairs.map((p, idx) => ({ idx, text: p.right }));
    shuffleArray(left);
    shuffleArray(right);

    ensureMatchingStylesInjected();

    const container = document.createElement('div');
    container.className = 'match-grid';

    const leftCol = document.createElement('div');
    const rightCol = document.createElement('div');

    // Build left list
    left.forEach(item => {
        const btn = document.createElement('button');
        btn.textContent = item.text;
        btn.className = 'match-btn';
        btn.dataset.side = 'left';
        btn.dataset.idx = String(item.idx);
        leftCol.appendChild(btn);
    });
    // Build right list
    right.forEach(item => {
        const btn = document.createElement('button');
        btn.textContent = item.text;
        btn.className = 'match-btn';
        btn.dataset.side = 'right';
        btn.dataset.idx = String(item.idx);
        rightCol.appendChild(btn);
    });

    container.appendChild(leftCol);
    container.appendChild(rightCol);
    optionsGridEl.classList.add('match-host');
    optionsGridEl.appendChild(container);
    // Inject style if not present
    ensureMatchingStylesInjected();

    // یکسان‌سازی ارتفاع همه دکمه‌ها برای تراز دقیق چپ/راست
    function uniformizeMatchHeights() {
        const allBtns = container.querySelectorAll('.match-btn');
        // ریست هر ارتفاع قبلی
        allBtns.forEach(b => b.style.height = '');
        let maxH = 0;
        allBtns.forEach(b => { maxH = Math.max(maxH, b.offsetHeight); });
        if (maxH > 0) allBtns.forEach(b => b.style.height = maxH + 'px');
    }
    // اجرا بعد از قرار گرفتن در DOM
    setTimeout(uniformizeMatchHeights, 0);
    // واکنش به تغییر اندازه پنجره
    window.addEventListener('resize', uniformizeMatchHeights, { passive: true });

    const selection = { left: null, right: null };
    let pairedCount = 0;

    function tryEnableNext() {
        checkBtnEl.disabled = pairedCount !== pairs.length;
    }

    optionsGridEl.addEventListener('click', onClickMatch);
    function onClickMatch(e) {
        if (matchingLocked) return;
        const btn = e.target && e.target.classList && e.target.classList.contains('match-btn') ? e.target : null;
        if (!btn) return;
        if (btn.classList.contains('paired')) return;
        if (btn.dataset.side === 'left') {
            clearSideSelection('left');
            selection.left = Number(btn.dataset.idx);
            btn.classList.add('selected');
        } else if (btn.dataset.side === 'right') {
            clearSideSelection('right');
            selection.right = Number(btn.dataset.idx);
            btn.classList.add('selected');
        }
        if (selection.left != null && selection.right != null) {
            const leftBtn = leftCol.querySelector(`.match-btn[data-idx="${selection.left}"]`);
            const rightBtn = rightCol.querySelector(`.match-btn[data-idx="${selection.right}"]`);
            // صحیح بودن جفت بر اساس مقدار متن‌ها (برای پوشش موارد تکراری مانند Adjective)
            const expectedRight = (pairs[selection.left]?.right || '').toString().trim().toLowerCase();
            const chosenRight = (rightBtn?.textContent || '').toString().trim().toLowerCase();
            const isCorrect = expectedRight === chosenRight;
            if (isCorrect) {
                [leftBtn, rightBtn].forEach(b => { if (b){ b.classList.remove('selected'); b.classList.add('paired'); b.disabled = true; b.setAttribute('aria-disabled','true'); } });
                pairedCount++;
            } else {
                // flash red and shake
                [leftBtn, rightBtn].forEach(b => { if (b){ b.classList.add('wrong','shake'); setTimeout(()=>{ b.classList.remove('shake','wrong','selected'); }, 450); } });
            }
            selection.left = selection.right = null;
            tryEnableNext();
        }
    }

    function clearSideSelection(side){
        const col = side === 'left' ? leftCol : rightCol;
        col.querySelectorAll('.match-btn.selected').forEach(b=>b.classList.remove('selected'));
    }

    checkBtnEl.textContent = 'CHECK';
    checkBtnEl.disabled = true;
    customCheckHandler = () => {
        if (isAnswered) return;
        isAnswered = true;
        stopTimer();
        // در این نسخه فقط اجازه‌ی قفل شدن جفت صحیح را می‌دهیم، پس اگر همه جفت‌ها قفل شدند یعنی درست است
        const isCorrect = (pairedCount === pairs.length);
        if (isCorrect) score++;
        // ثبت آیتم نتیجه به صورت خلاصه
        try {
            resultItems.push({
                id: currentQuestion.id,
                type: 'matching',
                text: currentQuestion.text,
                options: (currentQuestion.pairs || []).slice(),
                user_answer: `${pairedCount}/${pairs.length}`,
                answer: 'matching_pairs',
                is_correct: isCorrect,
                fa_explanation: currentQuestion.fa_explanation || '',
                kur_explanation: currentQuestion.kur_explanation || '',
                eng_explanation: currentQuestion.eng_explanation || ''
            });
        } catch(_) {}
        optionsGridEl.removeEventListener('click', onClickMatch);
        proceedNext();
    };
}

function normalizeAnswer(txt) {
    return (txt || '').toLowerCase().replace(/\s+/g, ' ').trim();
}

function proceedNext() {
    checkBtnEl.disabled = false;
    checkBtnEl.textContent = 'Next';
    customCheckHandler = null;
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        loadQuestion();
    } else {
        showResults();
    }
}

function ensureMatchingStylesInjected(){
    if (document.getElementById('matching-styles')) return;
    const style = document.createElement('style');
    style.id = 'matching-styles';
    style.textContent = `
    .match-host{display:flex;align-items:center;justify-content:center;padding:0 6px}
    /* جهت نمایش ستون‌ها به صورت چپ به راست تا ستون اول واقعاً در سمت چپ قرار گیرد */
    .match-grid{display:grid;grid-template-columns:repeat(2, minmax(120px, 1fr));gap:12px;width:100%;max-width:520px;margin:0 auto;direction:ltr}
    .match-grid>div{display:flex;flex-direction:column;gap:14px}
    .match-btn{background:#fff;border:2px solid #e0e0e0;border-radius:14px;padding:12px 14px;font-size:1rem;cursor:pointer;transition:all .18s ease;box-shadow:0 1px 4px rgba(0,0,0,.05);min-height:44px}
    .match-btn:hover{border-color:#c7d7ff;box-shadow:0 2px 10px rgba(64,87,255,.08)}
    .match-btn.selected{border-color:#4c8bf5;background:#eef6ff;box-shadow:0 0 0 4px rgba(76,139,245,.12)}
    .match-btn.paired{background:#e8f5e9;border-color:#66bb6a;color:#2e7d32;cursor:default;opacity:.98;box-shadow:0 0 0 4px rgba(102,187,106,.18)}
    .match-btn.wrong{background:#ffebee;border-color:#e57373;color:#c62828}
    @keyframes shakeX{10%,90%{transform:translateX(-2px)}20%,80%{transform:translateX(4px)}30%,50%,70%{transform:translateX(-6px)}40%,60%{transform:translateX(6px)}}
    .match-btn.shake{animation:shakeX .35s ease both}
    @media (max-width: 576px){
      .match-grid{gap:8px;max-width:340px;grid-template-columns:repeat(2, minmax(100px, 1fr));}
      .match-btn{padding:4px 6px;font-size:.78rem;min-height:30px;line-height:1.1}
    }
    `;
    document.head.appendChild(style);
}

function ensureGapfillStylesInjected(){
    if (document.getElementById('gapfill-styles')) return;
    const style = document.createElement('style');
    style.id = 'gapfill-styles';
    style.textContent = `
    .gap-wrapper{padding:0 18px 18px 18px;display:flex;justify-content:center}
    .gap-inline-wrap{display:inline-flex;align-items:baseline}
    .gap-input{width:100%;max-width:420px;padding:10px 12px;border:1px solid #d4d4d4;border-radius:8px;font:inherit;outline:none;transition:border-color .15s, box-shadow .15s;color:inherit;text-align:left;direction:ltr}
    .gap-input:focus{border-color:#4c8bf5;box-shadow:0 0 0 2px rgba(76,139,245,.12)}
    input.gap-inline{display:inline-block;vertical-align:baseline;border:none !important;border-bottom:2px solid #666 !important;background:transparent !important;font:inherit !important;color:inherit !important;outline:none !important;text-align:left;direction:ltr;margin:0 2px;width:auto;min-width:1ch;max-width:none;line-height:inherit;padding:0 2px !important;border-radius:0 !important;box-shadow:none !important;-webkit-appearance:none;-moz-appearance:textfield;appearance:none}
    input.gap-inline:focus{border-bottom-color:#4c8bf5 !important;box-shadow:none !important;outline:none !important}
    .gap-correct{border-bottom-color:#28a745 !important;color:#2e7d32 !important}
    .gap-correct{box-shadow:0 0 0 3px rgba(40,167,69,.18) inset}
    /* Full green border for correct state */
    input.gap-inline.gap-correct{border:2px solid #28a745 !important;border-radius:10px !important;background:#e8f5e9 !important;color:#2e7d32 !important;padding:2px 6px !important}
    .gap-input.gap-correct{border-color:#28a745 !important;background:#e8f5e9;color:#2e7d32}
    .gap-incorrect{border-bottom-color:#dc3545 !important;color:#dc3545 !important}
    .gap-feedback{margin-top:8px;font-size:0.95rem;color:#6c757d;text-align:center}
    .gap-status-banner{margin:8px 18px 0 18px;padding:12px 14px;border-radius:12px;background:#ffe6e6;border:1px solid #ffb3b3;color:#c62828}
    .gap-status-banner .gap-banner-title{font-weight:800;margin-bottom:6px}
    .gap-status-banner .gap-banner-answer{font-weight:600}
    .gap-status-banner .ltr{direction:ltr;text-align:left}
    .gap-correct-text{color:#2e7d32;font-weight:700}
    .hidden{display:none !important}
    .check-btn.error{background-color:#dc3545 !important;border-bottom-color:#b02a37 !important}
    input.gap-inline::-ms-clear{display:none}
    input.gap-inline::-webkit-outer-spin-button,input.gap-inline::-webkit-inner-spin-button{appearance:none;margin:0}
    `;
    document.head.appendChild(style);
}

// Mini translation tooltip logic for gap-fill emojis
function attachTranslateHandlers(root){
    if (!root) return;
    // inject minimal styles once
    if (!document.getElementById('translate-popover-styles')){
        const st = document.createElement('style');
        st.id = 'translate-popover-styles';
        st.textContent = `
        .tr-emoji{cursor:pointer; display:inline-flex; align-items:center; margin-left:4px}
        .tr-emoji svg{width:22px; height:22px; display:block}
        .tr-word{color:#a16207; font-weight:700; font-size:.86em}
        .tr-paren{color:#a16207; opacity:.95; font-size:.84em}
        .tr-group{display:inline-flex; align-items:baseline; gap:4px; white-space:nowrap}
        .attn{display:inline-block; animation:tr-pulse 1.8s ease-in-out infinite; transform-origin: 50% 60%}
        @keyframes tr-pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.03)}}
        .tr-pop{position:absolute; z-index:3000; background:#111827; color:#fff; padding:8px 10px; border-radius:10px; box-shadow:0 6px 20px rgba(0,0,0,.18); font-size:.85rem; max-width:240px}
        .tr-pop::after{content:''; position:absolute; top:-6px; inset-inline-start:14px; border:6px solid transparent; border-bottom-color:#111827}
        .tword{position:relative; cursor:pointer; border-bottom:2px dotted rgba(0,0,0,.18);}
        .tr-pop .tr-disc{display:block;margin-top:6px;font-size:.78rem;opacity:.85}
        `;
        document.head.appendChild(st);
    }
    // remove any existing popovers
    const removePop = () => document.querySelectorAll('.tr-pop').forEach(p=>p.remove());
    // helper: speak Persian
    const speakFa = (txt) => {
        try {
            if (!window.speechSynthesis || !txt) return;
            const synth = window.speechSynthesis;
            synth.cancel();
            const u = new SpeechSynthesisUtterance(String(txt));
            u.lang = 'fa-IR';
            const voices = synth.getVoices() || [];
            const fa = voices.find(v => /fa/i.test(v.lang) || /farsi|persian/i.test(v.name));
            if (fa) u.voice = fa;
            u.rate = 1; u.pitch = 1;
            synth.speak(u);
        } catch(_) {}
    };
    root.querySelectorAll('.tr-emoji').forEach(el=>{
        el.addEventListener('click', async (e)=>{
            e.preventDefault();
            e.stopPropagation();
            const word = el.getAttribute('data-word') || '';
            if (!word) return;
            removePop();
            const rect = el.getBoundingClientRect();
            const pop = document.createElement('div');
            pop.className = 'tr-pop';
            pop.textContent = '...';
            document.body.appendChild(pop);
            const top = window.scrollY + rect.bottom + 8;
            const left = window.scrollX + rect.left - 10;
            pop.style.top = top + 'px';
            pop.style.left = left + 'px';
            const siteLang = localStorage.getItem('siteLang') || 'fa';
            const target = (siteLang === 'ku') ? 'ckb' : 'fa';
            try {
                const res = await fetch('/api/translate', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ text: word, target }) });
                const data = await res.json();
                if (data && data.success) {
                    pop.textContent = data.translated;
                    if (target === 'fa') speakFa(data.translated);
                } else {
                    pop.textContent = 'ترجمه در دسترس نیست';
                }
            } catch(_){
                pop.textContent = 'خطا در ترجمه';
            }
            const onDocClick = (ev)=>{ if (!pop.contains(ev.target)) { pop.remove(); document.removeEventListener('click', onDocClick, true); } };
            document.addEventListener('click', onDocClick, true);
        });
    });
    // کلیک روی کلمات زیرخط‌گذاری‌شده نیز ترجمه را نشان می‌دهد
    root.querySelectorAll('.tword').forEach(el=>{
        el.addEventListener('click', async (e)=>{
            e.preventDefault(); e.stopPropagation();
            const word = (el.getAttribute('data-word') || el.textContent || '').trim();
            if (!word) return;
            document.querySelectorAll('.tr-pop').forEach(p=>p.remove());
            const rect = el.getBoundingClientRect();
            const pop = document.createElement('div');
            pop.className = 'tr-pop';
            pop.textContent = '...';
            document.body.appendChild(pop);
            pop.style.top = (window.scrollY + rect.bottom + 8) + 'px';
            pop.style.left = (window.scrollX + rect.left - 10) + 'px';
            const siteLang = localStorage.getItem('siteLang') || 'fa';
            const target = (siteLang === 'ku') ? 'ckb' : 'fa';
            try {
                const res = await fetch('/api/translate', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ text: word, target }) });
                const data = await res.json();
                if (data && data.success) pop.textContent = data.translated; else pop.textContent = 'ترجمه در دسترس نیست';
            } catch(_){ pop.textContent = 'خطا در ترجمه'; }
            const onDocClick = (ev)=>{ if (!pop.contains(ev.target)) { pop.remove(); document.removeEventListener('click', onDocClick, true); } };
            document.addEventListener('click', onDocClick, true);
        });
    });
}

// افزودن ایموجی ترجمه جمله در انتهای question_text
function appendSentenceTranslateEmoji(rawSentence){
    try{
        if (!questionTextEl) return;
        // از قبل اضافه نشده باشد
        if (questionTextEl.querySelector('.sent-emoji')) return;
        const host = document.createElement('span');
        host.className = 'sent-emoji';
        host.innerHTML = `<span class="tr-emoji" title="ترجمه جمله">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="22" height="22"><path fill="#CFD8DC" d="M15,13h25c1.104,0,2,0.896,2,2v25c0,1.104-0.896,2-2,2H26L15,13z"/><path fill="#546E7A" d="M26.832,34.854l-0.916-1.776l0.889-0.459c0.061-0.031,6.101-3.208,9.043-9.104l0.446-0.895l1.79,0.893l-0.447,0.895c-3.241,6.496-9.645,9.85-9.916,9.989L26.832,34.854z"/><path fill="#546E7A" d="M38.019 34l-.87-.49c-.207-.116-5.092-2.901-8.496-7.667l1.627-1.162c3.139 4.394 7.805 7.061 7.851 7.087L39 32.26 38.019 34zM26 22H40V24H26z"/><path fill="#546E7A" d="M32 20H34V24H32z"/><path fill="#2196F3" d="M33,35H8c-1.104,0-2-0.896-2-2V8c0-1.104,0.896-2,2-2h14L33,35z"/><path fill="#3F51B5" d="M26 42L23 35 33 35z"/><path fill="#FFF" d="M19.172,24h-4.36l-1.008,3H11l4.764-13h2.444L23,27h-2.805L19.172,24z M15.444,22h3.101l-1.559-4.714L15.444,22z"/></svg>
        </span>`;
        questionTextEl.appendChild(document.createTextNode(' '));
        questionTextEl.appendChild(host);
        // اتصال هندلر ترجمه جمله
        const el = host.querySelector('.tr-emoji');
        if (!el) return;
                    el.addEventListener('click', async (e)=>{
                e.preventDefault(); e.stopPropagation();
                
                // برای سوالات جای خالی، جواب درست را در متن قرار ده
                let sentence = rawSentence;
                const currentQuestion = questions[currentQuestionIndex];
                if (currentQuestion && (currentQuestion.gap_answer || currentQuestion.answer || currentQuestion.correct_answer)) {
                    const correctAnswer = String(currentQuestion.gap_answer || currentQuestion.answer || currentQuestion.correct_answer || '').trim();
                    if (correctAnswer) {
                        // جایگزینی [[1]] یا ___ با جواب درست
                        sentence = sentence.replace(/\[\[\s*1\s*\]\]|_{3,}/g, correctAnswer);
                    }
                }
                
                // نمایش پاپاور زیر آیکن
            document.querySelectorAll('.tr-pop').forEach(p=>p.remove());
            const rect = el.getBoundingClientRect();
            const pop = document.createElement('div');
            pop.className = 'tr-pop';
            pop.textContent = '...';
            document.body.appendChild(pop);
            pop.style.top = (window.scrollY + rect.bottom + 8) + 'px';
            pop.style.left = (window.scrollX + rect.left - 10) + 'px';
            const siteLang = localStorage.getItem('siteLang') || 'fa';
            const target = (siteLang === 'ku') ? 'ckb' : 'fa';
            try {
                const res = await fetch('/api/translate', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ text: sentence, target }) });
                const data = await res.json();
                const disc = (siteLang === 'ku')
                    ? 'وەرگێرانەی ئەژموونەیی/هوش‌مصنوعی – لەوانەیە بە تەواوی دروست نەبێت'
                    : 'ترجمهٔ ماشینی/هوش‌مصنوعی؛ ممکن است دقیق نباشد';
                if (data && data.success) {
                    pop.innerHTML = `<div>${data.translated}</div><span class="tr-disc">(${disc})</span>`;
                } else {
                    pop.textContent = 'ترجمه در دسترس نیست';
                }
            } catch(_){ pop.textContent = 'خطا در ترجمه'; }
            const onDocClick = (ev)=>{ if (!pop.contains(ev.target)) { pop.remove(); document.removeEventListener('click', onDocClick, true); } };
            document.addEventListener('click', onDocClick, true);
        });
    }catch(_){}
}

function loadQuestion() {
    // اضافه کردن یک چک برای اطمینان از وجود سوالات
    if (!questions || questions.length === 0) {
        questionTextEl.textContent = "سوالات آزمون یافت نشد. لطفاً به صفحه اصلی بازگردید.";
        optionsGridEl.innerHTML = '';
        checkBtnEl.disabled = true;
        progressBarInnerEl.style.width = '0%';
        if (questionCounterEl) questionCounterEl.textContent = ''; // پاک کردن شمارنده
        return;
    }

    // متوقف کردن تایمر قبلی
    stopTimer();
    
    // ریست کردن کلاس‌های تایمر
    if (timerEl) {
        timerEl.classList.remove('warning', 'danger');
    }
    
    // مخفی کردن پیام زمان تمام شده
    if (timeUpMessageEl) {
        timeUpMessageEl.style.display = 'none';
    }

    isAnswered = false;
    // پاک کردن بنر وضعیت (Incorrect/Correct) در صورت باقی ماندن از سوال قبلی
    const oldGapBanner = document.getElementById('gap-status-banner');
    if (oldGapBanner && oldGapBanner.parentNode) {
        oldGapBanner.parentNode.removeChild(oldGapBanner);
    }
    // حذف حالت خطا از دکمه در شروع سوال جدید
    if (checkBtnEl) {
        checkBtnEl.classList.remove('error');
    }
    const currentQuestion = questions[currentQuestionIndex];
    let qType = (currentQuestion.type || '').toLowerCase();
    const matchSet = new Set(['matching','match','pairs','pair','وصل','وصل‌کردنی','وصل کردنی']);
    const gapSet = new Set(['gapfill','gap','fillblank','fill-in-the-blank','fill','blank','fill_blank','fill blank']);
    // Prefer structural detection first
    if (Array.isArray(currentQuestion.pairs) && currentQuestion.pairs.length > 0) qType = 'matching';
    if (typeof currentQuestion.gap_answer === 'string' && currentQuestion.gap_answer.length > 0) qType = 'gapfill';
    if (matchSet.has(qType)) qType = 'matching';
    if (gapSet.has(qType)) qType = 'gapfill';
    if (!qType) {
        if (Array.isArray(currentQuestion.pairs) && currentQuestion.pairs.length > 0) qType = 'matching';
        else if (typeof currentQuestion.gap_answer === 'string' && currentQuestion.gap_answer.length > 0) qType = 'gapfill';
        else qType = 'mcq';
    }
    // Fallback: detect gapfill by pattern when no options
    if (qType === 'mcq') {
        const hasNoOptions = !Array.isArray(currentQuestion.options) || currentQuestion.options.length === 0;
        const looksLikeGap = /\[\[\s*\d+\s*\]\]|_{3,}/.test(String(currentQuestion.text || ''));
        if (hasNoOptions && looksLikeGap) {
            if (!currentQuestion.gap_answer) currentQuestion.gap_answer = currentQuestion.answer || '';
            qType = 'gapfill';
        }
    }
    if (qType === 'matching') {
        renderMatching(currentQuestion);
    } else if (qType === 'gapfill') {
        renderGapFill(currentQuestion);
    } else {
        renderMultipleChoice(currentQuestion);
    }
    const progress = ((currentQuestionIndex + 1) / questions.length) * 100;
    progressBarInnerEl.style.width = progress + '%';
    
    // شروع تایمر جدید
    startTimer();
    
    // === عنوان دکمه پیشفرض ===
    checkBtnEl.textContent = (qType === 'gapfill' || qType === 'matching') ? 'CHECK' : 'Next';
    // ====================================================
    checkBtnEl.disabled = true; // همچنان دکمه در ابتدا غیرفعال است

    // به روزرسانی شمارنده سوال
    if (questionCounterEl) {
        const lang = localStorage.getItem('siteLang') || 'fa';
        let counterText;
        if (lang === 'ku') {
            counterText = `پرسیار ${currentQuestionIndex + 1} لە ${questions.length}`;
        } else {
            counterText = `سوال ${currentQuestionIndex + 1} از ${questions.length}`;
        }
        
        // در آزمون ترکیبی نام گرامر را کنار شمارنده نمایش نده
        
        questionCounterEl.textContent = counterText;
    }
    
    // در آزمون ترکیبی، عنوان هدر را ثابت نگه دار
    if (getQuizType() === 'combined') {
        const quizHeader = document.querySelector('.quiz-header h1');
        if (quizHeader) {
            quizHeader.textContent = 'آزمون ترکیبی';
        }
    }

    // --- نمایش عنوان گرامر فعلی در عنوان صفحه و هدر آزمون ---
    if (getQuizType() === 'combined') {
        // عنوان تب و هدر برای آزمون ترکیبی ثابت بماند
        document.title = 'آزمون: آزمون ترکیبی';
        const quizHeader = document.querySelector('.quiz-header h1');
        if (quizHeader) {
            quizHeader.textContent = 'آزمون ترکیبی';
        }
    } else if (currentQuestion.content) {
        document.title = `آزمون: ${currentQuestion.content}`;
        const quizHeader = document.querySelector('.quiz-header h1');
        if (quizHeader) {
            quizHeader.textContent = currentQuestion.content;
        }
    }
    
    // نمایش دکمه گزارش در footer (همیشه)
    const reportContainer = document.querySelector('.report-container');
    if (reportContainer) {
        reportContainer.style.display = 'flex';
        if (reportQuestionBtnEl) {
            reportQuestionBtnEl.disabled = false;
        }
    }
    
    // مخفی کردن آیکن لامپ در ابتدای هر سوال
    if (explanationBtnEl) {
        explanationBtnEl.style.display = 'none';
        explanationBtnEl.disabled = true;
    }
}

function selectOption(selectedButton, question) {
    if (isAnswered) return;
    isAnswered = true;
    
    // متوقف کردن تایمر
    stopTimer();
    
    const selectedAnswer = selectedButton.textContent;
    const correctAnswer = question.answer;
    const allOptions = optionsGridEl.querySelectorAll('.option-btn');
    allOptions.forEach(btn => btn.disabled = true); // غیرفعال کردن همه گزینه‌ها بعد از انتخاب
    if (selectedAnswer === correctAnswer) {
        selectedButton.classList.add('correct');
        score++;
    } else {
        selectedButton.classList.add('incorrect');
        // نمایش پاسخ صحیح در صورت انتخاب غلط
        allOptions.forEach(btn => {
            if (btn.textContent === correctAnswer) {
                btn.classList.add('correct');
            }
        });
        // نمایش آیکن توضیحات بر اساس زبان و مقدار ستون مناسب
        const lang = localStorage.getItem('siteLang') || 'fa';
        let hasExplanation = false;
        if (lang === 'fa' && question.fa_explanation && question.fa_explanation.trim() !== '') {
            hasExplanation = true;
        } else if (lang === 'ku' && question.kur_explanation && question.kur_explanation.trim() !== '') {
            hasExplanation = true;
        }
        if (hasExplanation && explanationBtnEl) {
            explanationBtnEl.style.display = 'inline-block';
            explanationBtnEl.disabled = false;
        }
    }
    // ثبت آیتم نتیجه
    try {
        resultItems.push({
            id: question.id,
            type: 'mcq',
            text: question.text,
            options: (question.options || []).slice(),
            user_answer: selectedAnswer,
            answer: correctAnswer,
            is_correct: selectedAnswer === correctAnswer,
            fa_explanation: question.fa_explanation || '',
            kur_explanation: question.kur_explanation || '',
            eng_explanation: question.eng_explanation || ''
        });
    } catch(_) {}
    checkBtnEl.disabled = false;
    // === تغییر: عنوان دکمه را همچنان "Next" نگه می داریم ===
    checkBtnEl.textContent = 'Next';
    // ====================================================
}

async function saveResultToServer(quizData) {
    try {
        const response = await fetch('/api/save-result', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(quizData),
        });
        const result = await response.json();
        console.log('Server response:', result);
    } catch (error) {
        console.error('Error saving result:', error);
    }
}

function showResults() {
    // متوقف کردن تایمر
    stopTimer();
    
    quizMainViewEl.style.display = 'none';
    closeQuizBtnEl.style.display = 'none';
    resultsEl.style.display = 'block';

    // دریافت نام کامل کاربر از localStorage
    const userFullName = localStorage.getItem('userFullName') || 'کاربر';

    // محاسبه درصد
    const percentage = (score / questions.length) * 100;
    
    // ذخیره درصد برای استفاده بعدی
    window.quizPercentage = percentage;
    
    // نمایش زرق و برق و جشن اگر امتیاز بیشتر از 90 درصد بود
    if (percentage >= 90) {
        resultsGreetingEl.innerHTML = `
            <div class="celebration-container">
                <div class="celebration-emoji">🏆</div>
                <div class="celebration-text">تبریک! شما عالی بودید!</div>
            </div>
            <span>آفرین ${userFullName}!</span>
        `;
    } else {
        resultsGreetingEl.innerHTML = `<span>آفرین ${userFullName}!</span>`;
    }

    resultsTextEl.textContent = `شما به ${score} از ${questions.length} سوال پاسخ صحیح دادید.`;

    // نمایش modal برای پرسیدن درباره نمایش عمومی نتیجه
    showPublicResultModal();
}

// === Canvas Fireworks Celebration ===
let fireworksCanvas, fireworksCtx, fireworksActive = false, fireworks = [], particles = [], launchSounds = [], explosionSounds = [], fireworksAnimationId;
let celebrationTimer = null;
let celebrationDuration = 10000; // 10 seconds for automatic celebration
let clickBurstTimer = null;
let clickBurstDuration = 2000; // 2 seconds of extra burst after click
let lastClickTime = 0;
let clickCooldown = 300; // 300ms minimum between clicks to prevent spam
let maxFireworksPerSecond = 5; // Maximum fireworks that can be active at once
let fireworksCount = 0;
let totalFireworksTimer = null;
let totalFireworksDuration = 45000; // 45 seconds total fireworks system timeout

function setupFireworksCanvas() {
    if (fireworksCanvas) return;
    fireworksCanvas = document.createElement('canvas');
    fireworksCanvas.id = 'fireworks-canvas';
    fireworksCanvas.style.position = 'fixed';
    fireworksCanvas.style.left = '0';
    fireworksCanvas.style.top = '0';
    fireworksCanvas.style.width = '100vw';
    fireworksCanvas.style.height = '100vh';
    fireworksCanvas.style.pointerEvents = 'auto';
    fireworksCanvas.style.zIndex = '10010';
    fireworksCanvas.style.background = 'rgba(0,0,0,0.0)';
    document.body.appendChild(fireworksCanvas);
    resizeFireworksCanvas();
    fireworksCtx = fireworksCanvas.getContext('2d');
    window.addEventListener('resize', resizeFireworksCanvas);
    fireworksCanvas.addEventListener('click', (e) => {
        if (!fireworksActive) return;
        if (canTriggerFirework()) {
            const rect = fireworksCanvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            triggerFirework(x, y);
        }
    });
    
    // Add click listener to quiz results container
    const resultsContainer = document.getElementById('quiz-results');
    if (resultsContainer) {
        resultsContainer.addEventListener('click', (e) => {
            if (!fireworksActive) return;
            if (!e.target.closest('button') && !e.target.matches('button')) {
                if (canTriggerFirework()) {
                    const rect = fireworksCanvas.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    triggerFirework(x, y);
                }
            }
        });
    }
}
function resizeFireworksCanvas() {
    if (!fireworksCanvas) return;
    fireworksCanvas.width = window.innerWidth;
    fireworksCanvas.height = window.innerHeight;
}

function canTriggerFirework() {
    const now = Date.now();
    if (now - lastClickTime < clickCooldown) {
        return false;
    }
    if (fireworksCount >= maxFireworksPerSecond) {
        return false;
    }
    return true;
}

function triggerFirework(x, y) {
    lastClickTime = Date.now();
    fireworksCount++;
    fireworks.push(new Firework(x, fireworksCanvas.height, y));
    // If celebration is over, start a short burst of automatic fireworks
    if (!celebrationTimer) {
        startClickBurst();
    }
    // Reset fireworks count after a delay
    setTimeout(() => {
        fireworksCount = Math.max(0, fireworksCount - 1);
    }, 1000);
}

// === Firework and Particle Classes ===
class Firework {
    constructor(x, startY, targetY) {
        this.x = x || Math.random() * fireworksCanvas.width * 0.8 + fireworksCanvas.width * 0.1;
        this.y = fireworksCanvas.height;
        this.targetY = targetY || Math.random() * fireworksCanvas.height * 0.4 + fireworksCanvas.height * 0.1;
        this.color = randomColor();
        this.trail = [];
        this.trailLength = 8;
        this.vx = (Math.random() - 0.5) * 2;
        this.vy = -(Math.random() * 7 + 10);
        this.exploded = false;
        this.shimmer = Math.random() < 0.3;
        createFireworkLaunchSound(); // Use new sound function
    }
    update() {
        if (!this.exploded) {
            this.trail.push({x: this.x, y: this.y});
            if (this.trail.length > this.trailLength) this.trail.shift();
            this.x += this.vx;
            this.y += this.vy;
            this.vy += 0.18; // gravity
            if (this.vy > 0 || this.y <= this.targetY) {
                this.explode();
            }
        }
    }
    draw(ctx) {
        // Draw trail
        ctx.save();
        ctx.strokeStyle = this.color;
        ctx.lineWidth = 2;
        ctx.beginPath();
        for (let i = 0; i < this.trail.length; i++) {
            const p = this.trail[i];
            if (i === 0) ctx.moveTo(p.x, p.y);
            else ctx.lineTo(p.x, p.y);
        }
        ctx.stroke();
        ctx.restore();
        // Draw rocket
        ctx.save();
        ctx.beginPath();
        ctx.arc(this.x, this.y, 4, 0, 2 * Math.PI);
        ctx.fillStyle = this.color;
        ctx.shadowColor = this.color;
        ctx.shadowBlur = 12;
        ctx.globalAlpha = 0.9;
        ctx.fill();
        ctx.restore();
    }
    explode() {
        if (this.exploded) return;
        this.exploded = true;
        const count = Math.floor(Math.random() * 24) + 24;
        for (let i = 0; i < count; i++) {
            const angle = (i / count) * 2 * Math.PI;
            const speed = Math.random() * 4 + 2;
            particles.push(new Particle(this.x, this.y, this.color, angle, speed));
        }
        createFireworkExplosionSound(); // Use new sound function
    }
}
class Particle {
    constructor(x, y, color, angle, speed) {
        this.x = x;
        this.y = y;
        this.color = color;
        this.vx = Math.cos(angle) * speed + (Math.random() - 0.5) * 1.2;
        this.vy = Math.sin(angle) * speed + (Math.random() - 0.5) * 1.2;
        this.alpha = 1;
        this.life = Math.random() * 0.7 + 0.8;
        this.shimmer = Math.random() < 0.3;
    }
    update() {
        this.x += this.vx;
        this.y += this.vy;
        this.vy += 0.04; // gravity
        this.alpha -= 0.012 * this.life;
        if (this.shimmer && Math.random() < 0.2) this.alpha -= 0.04;
    }
    draw(ctx) {
        ctx.save();
        ctx.globalAlpha = Math.max(this.alpha, 0);
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.shimmer ? 2.5 : 1.5, 0, 2 * Math.PI);
        ctx.fillStyle = this.color;
        ctx.shadowColor = this.color;
        ctx.shadowBlur = this.shimmer ? 16 : 8;
        ctx.fill();
        ctx.restore();
    }
}
function randomColor() {
    const colors = ['#ff6b6b', '#ffd93d', '#6bcf7f', '#4d9de0', '#e15759', '#fff', '#f0f', '#0ff', '#ff0', '#0f0', '#f90'];
    return colors[Math.floor(Math.random() * colors.length)];
}

function playRandomSound(arr) {
    if (!arr.length) return;
    const audio = arr[Math.floor(Math.random() * arr.length)].cloneNode();
    audio.volume = 0.7;
    audio.play();
}

function createFireworkLaunchSound() {
    try {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        const filter = audioContext.createBiquadFilter();
        
        oscillator.connect(filter);
        filter.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        // Launch sound: rising pitch with filter sweep
        oscillator.frequency.setValueAtTime(200, audioContext.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(800, audioContext.currentTime + 0.3);
        
        filter.type = 'lowpass';
        filter.frequency.setValueAtTime(2000, audioContext.currentTime);
        filter.frequency.exponentialRampToValueAtTime(200, audioContext.currentTime + 0.3);
        
        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
        
        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + 0.3);
    } catch (e) {
        console.log('Audio not supported');
    }
}

function createFireworkExplosionSound() {
    try {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        const filter = audioContext.createBiquadFilter();
        
        oscillator.connect(filter);
        filter.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        // Explosion sound: burst of noise with filter
        oscillator.type = 'sawtooth';
        oscillator.frequency.setValueAtTime(100, audioContext.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(50, audioContext.currentTime + 0.5);
        
        filter.type = 'highpass';
        filter.frequency.setValueAtTime(1000, audioContext.currentTime);
        filter.frequency.exponentialRampToValueAtTime(200, audioContext.currentTime + 0.5);
        
        gainNode.gain.setValueAtTime(0.4, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
        
        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + 0.5);
    } catch (e) {
        console.log('Audio not supported');
    }
}

function preloadFireworksSounds() {
    // Using Web Audio API instead of file-based sounds
    // No need to preload files
    console.log('Fireworks sounds ready (Web Audio API)');
}

function startFireworksCelebration() {
    setupFireworksCanvas();
    preloadFireworksSounds();
    fireworksActive = true;
    fireworks = [];
    particles = [];
    
    // Launch initial fireworks for celebration
    for (let i = 0; i < 5; i++) {
        setTimeout(() => {
            fireworks.push(new Firework());
        }, i * 400);
    }
    
    // Start celebration timer - stop automatic fireworks after time limit
    if (celebrationTimer) clearTimeout(celebrationTimer);
    celebrationTimer = setTimeout(() => {
        // Stop automatic fireworks but keep canvas active for manual clicks
        celebrationTimer = null;
    }, celebrationDuration);
    
    // Start total fireworks system timer - completely disable after 45 seconds
    if (totalFireworksTimer) clearTimeout(totalFireworksTimer);
    totalFireworksTimer = setTimeout(() => {
        stopFireworksCelebration();
    }, totalFireworksDuration);
    
    animateFireworks();
}
function stopFireworksCelebration() {
    fireworksActive = false;
    if (celebrationTimer) {
        clearTimeout(celebrationTimer);
        celebrationTimer = null;
    }
    if (totalFireworksTimer) {
        clearTimeout(totalFireworksTimer);
        totalFireworksTimer = null;
    }
    if (fireworksCanvas) fireworksCanvas.style.display = 'none';
    cancelAnimationFrame(fireworksAnimationId);
}
function animateFireworks() {
    if (!fireworksActive) return;
    fireworksCanvas.style.display = 'block';
    fireworksCtx.clearRect(0, 0, fireworksCanvas.width, fireworksCanvas.height);
    // Update and draw fireworks
    for (let i = fireworks.length - 1; i >= 0; i--) {
        fireworks[i].update();
        fireworks[i].draw(fireworksCtx);
        if (fireworks[i].exploded) {
            fireworks.splice(i, 1);
            fireworksCount = Math.max(0, fireworksCount - 1);
        }
    }
    // Update and draw particles
    for (let i = particles.length - 1; i >= 0; i--) {
        particles[i].update();
        particles[i].draw(fireworksCtx);
        if (particles[i].alpha <= 0) particles.splice(i, 1);
    }
    // Only launch automatic fireworks during celebration period or click burst
    if (celebrationTimer && Math.random() < 0.03 && fireworksCount < maxFireworksPerSecond) {
        fireworks.push(new Firework());
        fireworksCount++;
    }
    fireworksAnimationId = requestAnimationFrame(animateFireworks);
}

function showCelebration() {
    startFireworksCelebration();
    // ایجاد عناصر زرق و برق و جشن
    const celebrationElements = [
        '🎉', '🎊', '⭐', '🌟', '💫', '✨', '🎈', '🎆', '🎇', '🎊', '🎋', '🎍', '🎎', '🎏', '🎐', '🎀', '🎁', '🎂', '🎃', '🎄'
    ];
    
    // ایجاد 30 عنصر زرق و برق
    for (let i = 0; i < 30; i++) {
        const sparkle = document.createElement('div');
        sparkle.className = 'celebration-sparkle';
        sparkle.textContent = celebrationElements[Math.floor(Math.random() * celebrationElements.length)];
        sparkle.style.left = Math.random() * 100 + '%';
        sparkle.style.animationDelay = Math.random() * 2 + 's';
        sparkle.style.animationDuration = (Math.random() * 2 + 3) + 's';
        document.body.appendChild(sparkle);
        
        // حذف عنصر بعد از انیمیشن
        setTimeout(() => {
            if (sparkle.parentNode) {
                sparkle.parentNode.removeChild(sparkle);
            }
        }, 5000);
    }
    
    // ایجاد فشفشه‌های اضافی
    createFireworks();
    
    // پخش صدای جشن (اختیاری)
    playCelebrationSound();
}

function createFireworks() {
    const fireworkColors = [
        'radial-gradient(circle, #ff6b6b, #ffd93d, #6bcf7f, #4d9de0, #e15759)',
        'radial-gradient(circle, #ffd93d, #ff6b6b, #4d9de0, #6bcf7f, #e15759)',
        'radial-gradient(circle, #6bcf7f, #ffd93d, #ff6b6b, #e15759, #4d9de0)',
        'radial-gradient(circle, #4d9de0, #6bcf7f, #ffd93d, #ff6b6b, #e15759)',
        'radial-gradient(circle, #e15759, #4d9de0, #6bcf7f, #ffd93d, #ff6b6b)'
    ];

    // تعداد فشفشه‌ها
    const fireworkCount = 7;
    for (let i = 0; i < fireworkCount; i++) {
        setTimeout(() => {
            // نقطه افقی تصادفی
            const leftPercent = Math.random() * 80 + 10;
            // نقطه نهایی عمودی (بالا)
            const topPercent = Math.random() * 30 + 10;
            // رنگ تصادفی
            const color = fireworkColors[i % fireworkColors.length];

            // ایجاد راکت فشفشه
            const rocket = document.createElement('div');
            rocket.className = 'firework-rocket';
            rocket.style.left = leftPercent + '%';
            rocket.style.bottom = '-40px';
            rocket.style.background = color;
            document.body.appendChild(rocket);

            // انیمیشن پرتاب به بالا
            setTimeout(() => {
                rocket.style.transition = 'bottom 0.7s cubic-bezier(0.22, 1, 0.36, 1)';
                rocket.style.bottom = (100 - topPercent) + 'vh';
            }, 10);

            // پس از رسیدن به بالا، انفجار و حذف راکت
            setTimeout(() => {
                // حذف راکت
                if (rocket.parentNode) rocket.parentNode.removeChild(rocket);
                // انفجار (ذرات)
                const firework = document.createElement('div');
                firework.className = 'firework';
                firework.style.left = leftPercent + '%';
                firework.style.top = topPercent + '%';
                firework.style.background = color;
                document.body.appendChild(firework);
                // ذرات انفجار
                for (let j = 0; j < 14; j++) {
                    const particle = document.createElement('div');
                    particle.className = 'firework-particle';
                    particle.style.setProperty('--rotation', `${j * (360/14)}deg`);
                    particle.style.background = color;
                    firework.appendChild(particle);
                }
                // پخش صدای انفجار
                playFireworkExplosionSound();
                // حذف انفجار بعد از انیمیشن
                setTimeout(() => {
                    if (firework.parentNode) firework.parentNode.removeChild(firework);
                }, 1800);
            }, 800); // مدت زمان پرتاب
        }, i * 700);
    }
}

// Helper to preload and play the firework explosion sound
let fireworkExplosionAudio = null;
function preloadFireworkExplosionSound() {
    if (!fireworkExplosionAudio) {
        fireworkExplosionAudio = new Audio('/static/sounds/firework-explosion.mp3'); // Add your sound file here
        fireworkExplosionAudio.load();
    }
}
function playFireworkExplosionSound() {
    if (!fireworkExplosionAudio) preloadFireworkExplosionSound();
    if (fireworkExplosionAudio) {
        // Clone for overlapping sounds
        const sound = fireworkExplosionAudio.cloneNode();
        sound.volume = 0.7;
        sound.play();
    }
}

function playCelebrationSound() {
    // فقط موزیک wow
    playWowMusic();
}

function playWowMusic() {
    // ایجاد موزیک wow با Web Audio API
    try {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        
        // موزیک wow - آکوردهای جشن
        const wowMelody = [
            // آکورد اول: C major
            { freqs: [523.25, 659.25, 783.99], duration: 0.4 },
            // آکورد دوم: F major
            { freqs: [698.46, 880.00, 1046.50], duration: 0.4 },
            // آکورد سوم: G major
            { freqs: [783.99, 987.77, 1174.66], duration: 0.4 },
            // آکورد چهارم: C major (octave)
            { freqs: [1046.50, 1318.51, 1567.98], duration: 0.6 }
        ];
        
        let currentTime = audioContext.currentTime;
        
        wowMelody.forEach((chord, index) => {
            chord.freqs.forEach((freq, freqIndex) => {
                const oscillator = audioContext.createOscillator();
                const gainNode = audioContext.createGain();
                
                oscillator.connect(gainNode);
                gainNode.connect(audioContext.destination);
                
                oscillator.frequency.setValueAtTime(freq, currentTime);
                oscillator.type = 'triangle'; // صدای گرم‌تر
                
                gainNode.gain.setValueAtTime(0, currentTime);
                gainNode.gain.linearRampToValueAtTime(0.1, currentTime + 0.05);
                gainNode.gain.linearRampToValueAtTime(0, currentTime + chord.duration);
                
                oscillator.start(currentTime);
                oscillator.stop(currentTime + chord.duration);
            });
            
            currentTime += chord.duration;
        });
        
    } catch (e) {
        console.log('Wow music not supported');
    }
}

function showPublicResultModal() {
    const modal = document.getElementById('public-result-modal-overlay');
    modal.classList.remove('hidden');
}

function saveResultWithPrivacy(isPublic) {
    // استفاده از تابع کمکی
    const quizName = getQuizName();
    const userFullName = localStorage.getItem('userFullName') || 'کاربر';

    // دریافت گرامرهای انتخاب شده برای آزمون ترکیبی از متغیر سراسری
    let selectedGrammars = null;
    if (isCombinedTestSession && combinedSelectedGrammars.length > 0) {
        selectedGrammars = combinedSelectedGrammars.join(', ');
    }

    const resultData = {
        user_name: userFullName,
        quiz_name: quizName,
        score: score,
        total_questions: questions.length,
        public: isPublic,
        selected_grammars: selectedGrammars,
        items: resultItems
    };
    
    saveResultToServer(resultData);
    // پاکسازی داده آزمون ترکیبی از sessionStorage پس از ذخیره نتیجه
    try { sessionStorage.removeItem('combinedTestData'); } catch (e) {}
    personalQuizCode = null;
    localStorage.removeItem('currentQuizCode');
    
    // نمایش زرق و برق و جشن اگر امتیاز بیشتر از 90 درصد بود
    if (window.quizPercentage >= 90) {
        showCelebration();
    }
}

// تابع نمایش مودال توضیحات آموزشی
function showExplanationModal() {
    const currentQuestion = questions[currentQuestionIndex];
    const lang = localStorage.getItem('siteLang') || 'fa';
    
    // تنظیم محتوای هر دو تب
    const faContent = currentQuestion.fa_explanation || '';
    const kuContent = currentQuestion.kur_explanation || '';
    const enContent = currentQuestion.eng_explanation || '';
    
    // نمایش محتوای هر دو تب
    const faContentEl = document.getElementById('explanation-content-fa');
    const kuContentEl = document.getElementById('explanation-content-ku');
    const enContentEl = document.getElementById('explanation-content-en');
    
    if (faContentEl) faContentEl.textContent = faContent;
    if (kuContentEl) kuContentEl.textContent = kuContent;
    if (enContentEl) enContentEl.textContent = enContent;
    
    // تنظیم تب فعال بر اساس زبان سایت
    const tabBtns = document.querySelectorAll('.tab-btn');
    const contentDivs = document.querySelectorAll('.explanation-content');
    
    // حذف کلاس active از همه تب‌ها و محتوا
    tabBtns.forEach(btn => btn.classList.remove('active'));
    contentDivs.forEach(div => div.classList.remove('active'));
    
    // فعال کردن تب مناسب
    if (lang === 'ku') {
        const kuTab = document.querySelector('.tab-btn[data-lang="ku"]');
        const kuContentDiv = document.getElementById('explanation-content-ku');
        if (kuTab) kuTab.classList.add('active');
        if (kuContentDiv) kuContentDiv.classList.add('active');
    } else if (lang === 'en' || lang === 'eng') {
        const enTab = document.querySelector('.tab-btn[data-lang="en"]');
        const enContentDiv = document.getElementById('explanation-content-en');
        if (enTab) enTab.classList.add('active');
        if (enContentDiv) enContentDiv.classList.add('active');
    } else {
        const faTab = document.querySelector('.tab-btn[data-lang="fa"]');
        const faContentDiv = document.getElementById('explanation-content-fa');
        if (faTab) faTab.classList.add('active');
        if (faContentDiv) faContentDiv.classList.add('active');
    }
    
    // تغییر عنوان و دکمه بر اساس زبان
    const modalTitle = document.querySelector('#explanation-modal-overlay .confirm-modal h2');
    const modalBtn = document.getElementById('explanation-ok-btn');
    if (lang === 'ku') {
        if (modalTitle) modalTitle.innerHTML = '<span class="emoji">👨‍🏫</span> تێبینی فێرکاری';
        if (modalBtn) modalBtn.textContent = 'تێگەیشتم';
    } else {
        if (modalTitle) modalTitle.innerHTML = '<span class="emoji">👨‍🏫</span> نکته آموزشی';
        if (modalBtn) modalBtn.textContent = 'متوجه شدم';
    }
    
    if (explanationModalOverlayEl) {
        explanationModalOverlayEl.classList.remove('hidden');
    }
}

// تابع بستن مودال توضیحات آموزشی
function closeExplanationModal() {
    if (explanationModalOverlayEl) {
        explanationModalOverlayEl.classList.add('hidden');
    }
}

// --- Event Listeners ---
checkBtnEl.addEventListener('click', (e) => {
    if (typeof customCheckHandler === 'function') {
        customCheckHandler(e);
        return;
    }
    // اگر کاربر جواب نداده و زمان تمام شده، اجازه رفتن به سوال بعدی
    if (!isAnswered && timeLeft > 0) return;
    
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        loadQuestion();
    } else {
        showResults();
    }
});

restartBtnEl.addEventListener('click', () => { 
    stopFireworksCelebration();
    window.location.reload(); 
});

closeQuizBtnEl.addEventListener('click', (event) => {
    event.preventDefault();
    confirmModalOverlayEl.classList.remove('hidden');
});

confirmNoBtnEl.addEventListener('click', () => {
    confirmModalOverlayEl.classList.add('hidden');
});

// هر دو دکمه خروج/بازگشت به لیست، کاربر را به صفحه مناسب بازمی‌گردانند.
confirmYesBtnEl.addEventListener('click', () => { 
    stopFireworksCelebration();
    // اگر در حالت تست کتاب هستیم، به /books_vocab برگردیم
    if (window.location.pathname.startsWith('/books_vocab/')) {
        window.location.href = '/books_vocab';
    } else {
        window.location.href = "/grammar_tests"; 
    }
});
returnToListBtnEl.addEventListener('click', () => { 
    stopFireworksCelebration();
    if (window.location.pathname.startsWith('/books_vocab/')) {
        window.location.href = '/books_vocab';
    } else {
        window.location.href = "/grammar_tests"; 
    }
});

// Event listeners برای توضیحات آموزشی
if (explanationBtnEl) {
    explanationBtnEl.addEventListener('click', showExplanationModal);
}

if (explanationOkBtnEl) {
    explanationOkBtnEl.addEventListener('click', closeExplanationModal);
}

// Event listeners برای تب‌های زبان
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('tab-btn')) {
        const lang = e.target.getAttribute('data-lang');
        
        // حذف کلاس active از همه تب‌ها و محتوا
        const tabBtns = document.querySelectorAll('.tab-btn');
        const contentDivs = document.querySelectorAll('.explanation-content');
        
        tabBtns.forEach(btn => btn.classList.remove('active'));
        contentDivs.forEach(div => div.classList.remove('active'));
        
        // فعال کردن تب انتخاب شده
        e.target.classList.add('active');
        const targetContent = document.getElementById(`explanation-content-${lang}`);
        if (targetContent) targetContent.classList.add('active');
    }
});

// بستن مودال توضیحات با کلیک روی overlay
if (explanationModalOverlayEl) {
    explanationModalOverlayEl.addEventListener('click', function(e) {
        if (e.target === explanationModalOverlayEl) {
            closeExplanationModal();
        }
    });
}


// بارگذاری اولین سوال هنگام شروع
loadQuestion();

// === Localize exit modal for Kurdish ===
document.addEventListener('DOMContentLoaded', function() {
    const lang = localStorage.getItem('siteLang') || 'fa';
    if (lang === 'ku') {
        const exitTitle = document.querySelector('#confirm-modal-overlay .confirm-modal h2');
        const exitMsg = document.querySelector('#confirm-modal-overlay .confirm-modal p');
        const exitYes = document.getElementById('confirm-yes-btn');
        const exitNo = document.getElementById('confirm-no-btn');
        if (exitTitle) exitTitle.textContent = 'دەرچوون لە تاقیکردنەوە';
        if (exitMsg) exitMsg.textContent = 'دڵنیایت دەتەوێت لە تاقیکردنەوە بڕۆیتە دەرەوە؟   ';
        if (exitYes) exitYes.textContent = 'بەڵێ، دەڕۆمە دەرەوە';
        if (exitNo) exitNo.textContent = 'نەخێر، بەردەوام بم';
    }
});

// === تابع گزارش سوال ===
async function showReportModal() {
    if (!questions || currentQuestionIndex >= questions.length) {
        return;
    }
    
    const currentQuestion = questions[currentQuestionIndex];
    
    try {
        // بررسی اینکه آیا سوال قبلاً گزارش شده است
        const checkResponse = await fetch('/api/check-question-reported', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                question_id: currentQuestion.id
            })
        });
        
        const checkResult = await checkResponse.json();
        
        if (checkResult.success && checkResult.reported) {
            // نمایش هشدار که سوال قبلاً گزارش شده
            showAlreadyReportedWarning(checkResult.message);
        } else {
    // نمایش Modal گزارش
    document.getElementById('report-modal').classList.remove('hidden');
    // پاک کردن انتخاب قبلی
    document.getElementById('report-reason').value = '';
        }
    } catch (error) {
        console.error('Error checking if question reported:', error);
        // در صورت خطا، مستقیماً modal گزارش را نمایش بده
        document.getElementById('report-modal').classList.remove('hidden');
        document.getElementById('report-reason').value = '';
    }
}

function showAlreadyReportedWarning(message) {
    const modal = document.getElementById('already-reported-modal-overlay');
    const messageEl = document.getElementById('already-reported-message');
    
    if (messageEl) {
        messageEl.textContent = message;
    }
    
    modal.classList.remove('hidden');
}

function closeReportModal() {
    // بستن Modal گزارش
    document.getElementById('report-modal').classList.add('hidden');
}

function showReportSuccessModal() {
  document.getElementById('report-success-modal').classList.remove('hidden');
}
document.addEventListener('DOMContentLoaded', function() {
  var okBtn = document.getElementById('report-success-ok-btn');
  if (okBtn) {
    okBtn.onclick = function() {
      document.getElementById('report-success-modal').classList.add('hidden');
      closeReportModal();
    };
  }
});

async function submitReport() {
    if (!questions || currentQuestionIndex >= questions.length) {
        return;
    }
    
    const currentQuestion = questions[currentQuestionIndex];
    
    // دریافت دلیل گزارش
    const reportReasonSelect = document.getElementById('report-reason');
    const reportReason = reportReasonSelect.value;
    const errorSpan = document.getElementById('report-reason-error');
    if (!reportReason) {
        errorSpan.style.display = 'block';
        return;
    } else {
        errorSpan.style.display = 'none';
    }
    
    // دریافت متن فارسی دلیل گزارش
    const selectedOption = reportReasonSelect.options[reportReasonSelect.selectedIndex];
    const persianReason = selectedOption.textContent;
    
    // غیرفعال کردن دکمه ثبت
    const submitBtn = document.getElementById('submit-report-btn');
    submitBtn.disabled = true;
    submitBtn.textContent = 'در حال ثبت...';
    
    try {
        // استفاده از توابع کمکی
        const quizType = getQuizType();
        const quizName = getQuizName();
        // دریافت نام کاربر از localStorage
        const userFullName = localStorage.getItem('userFullName') || '';
        
        // مقدار content را برابر با quizName قرار بده
        const contentValue = quizName;
        // تعیین مقدار question_type طبق منطق جدید
        let questionTypeValue = '';
        if (currentQuestion.code && currentQuestion.code.trim() !== '') {
            questionTypeValue = currentQuestion.code;
        } else if (currentQuestion.content && currentQuestion.content.trim() !== '') {
            questionTypeValue = currentQuestion.content;
        } else {
            questionTypeValue = '';
        }
        
        // تشخیص نوع سؤال و تنظیم داده‌های مناسب
        let optionsData, correctAnswerData;
        const questionType = (currentQuestion.type || '').toLowerCase();
        
        if (questionType === 'matching' || Array.isArray(currentQuestion.pairs)) {
            // برای سؤالات مچینگ: pairs را به عنوان options ارسال کن
            optionsData = currentQuestion.pairs || [];
            correctAnswerData = 'matching_pairs'; // نشان‌دهنده نوع سؤال
        } else if (questionType === 'gapfill' || currentQuestion.gap_answer) {
            // برای سؤالات جای خالی
            optionsData = { gap_answer: currentQuestion.gap_answer };
            correctAnswerData = currentQuestion.gap_answer || '';
        } else {
            // برای سؤالات چهارگزینه‌ای
            optionsData = currentQuestion.options || [];
            correctAnswerData = currentQuestion.answer || '';
        }
        
        const reportData = {
            question_id: currentQuestion.id,
            question_text: currentQuestion.text,
            options: optionsData,
            correct_answer: correctAnswerData,
            quiz_name: quizName,
            content: contentValue, // مقدار content برابر با quizName
            question_type: questionTypeValue, // مقدار دقیق question_type طبق منطق جدید
            quiz_type: quizType,
            reported_reason: persianReason,  // ارسال متن فارسی به جای enum
            user_name: userFullName, // اضافه کردن نام کاربر
            // ارسال توضیحات (ممکن است خالی باشند)
            fa_explanation: currentQuestion.fa_explanation || '',
            kur_explanation: currentQuestion.kur_explanation || '',
            eng_explanation: currentQuestion.eng_explanation || ''
        };
        
        const response = await fetch('/api/report-question', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(reportData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            // نمایش پیام موفقیت
            showReportSuccessModal();
            closeReportModal();
        } else {
            alert('خطا: ' + result.message);
        }
    } catch (error) {
        console.error('Error reporting question:', error);
        alert('خطا در ارتباط با سرور');
    } finally {
        // فعال کردن مجدد دکمه
        submitBtn.disabled = false;
        submitBtn.textContent = 'ثبت گزارش';
    }
}

// تابع کمکی برای تشخیص نوع آزمون
function getQuizType() {
    if (isCombinedTestSession) {
        return 'combined';
    } else if (localStorage.getItem('currentQuizTitle')) {
        return 'personal';
    } else {
        return 'general';
    }
}

// تابع کمکی برای دریافت quiz_name
function getQuizName() {
    if (isCombinedTestSession) {
        // عنوان قبلاً در currentQuizTitle تنظیم شده است
        return currentQuizTitle || 'آزمون ترکیبی';
    } else if (personalQuizCode) {
        return personalQuizCode;
    } else if (questions && questions.length > 0 && questions[0].content) {
        return questions[0].content;
    } else {
        return currentQuizTitle;
    }
}

// اضافه کردن Event Listener برای دکمه گزارش
    if (reportQuestionBtnEl) {
        reportQuestionBtnEl.addEventListener('click', showReportModal);
    }
    
    // اضافه کردن event listener برای دکمه ثبت گزارش
    const submitReportBtn = document.getElementById('submit-report-btn');
    if (submitReportBtn) {
        submitReportBtn.addEventListener('click', submitReport);
    }
    
    // اضافه کردن event listener برای دکمه OK در modal هشدار
    const alreadyReportedOkBtn = document.getElementById('already-reported-ok-btn');
    if (alreadyReportedOkBtn) {
        alreadyReportedOkBtn.addEventListener('click', function() {
            document.getElementById('already-reported-modal-overlay').classList.add('hidden');
        });
    }
    
    // اضافه کردن event listeners برای modal نتیجه عمومی
    const publicResultYesBtn = document.getElementById('public-result-yes-btn');
    const publicResultNoBtn = document.getElementById('public-result-no-btn');
    
    if (publicResultYesBtn) {
        publicResultYesBtn.addEventListener('click', function() {
            document.getElementById('public-result-modal-overlay').classList.add('hidden');
            saveResultWithPrivacy(true); // نتیجه عمومی
        });
    }
    
    if (publicResultNoBtn) {
        publicResultNoBtn.addEventListener('click', function() {
            document.getElementById('public-result-modal-overlay').classList.add('hidden');
            saveResultWithPrivacy(false); // نتیجه خصوصی
        });
    }