// static/js/quiz.js

let score = 0;
let currentQuestionIndex = 0;
let isAnswered = false;

// متغیر سراسری questions.
// این متغیر حالا از 'window.initialQuizQuestions' مقداردهی اولیه می‌شود که توسط Flask تنظیم شده است.
// اگر 'window.initialQuizQuestions' وجود نداشته باشد (مثلا برای آزمون های شخصی سازی شده)،
// آن را به یک آرایه خالی مقداردهی می کنیم.
let questions = window.initialQuizQuestions || [];


let currentQuizTitle = document.title.replace('آزمون: ', ''); // عنوان اولیه از Flask


// === بخش جدید: بارگذاری سوالات شخصی سازی شده از localStorage ===
const storedQuestions = localStorage.getItem('currentQuizQuestions');
const storedTitle = localStorage.getItem('currentQuizTitle');

if (storedQuestions && storedTitle) {
    // اگر سوالات شخصی سازی شده در localStorage یافت شد:
    questions = JSON.parse(storedQuestions); // متغیر questions را با سوالات شخصی جایگزین می‌کند.
    currentQuizTitle = storedTitle; // عنوان را با عنوان شخصی جایگزین می‌کند.
    document.title = `آزمون: ${currentQuizTitle}`; // عنوان تب مرورگر را به‌روزرسانی می‌کند.

    // بلافاصله پس از استفاده، اطلاعات را از localStorage پاک می‌کنیم.
    localStorage.removeItem('currentQuizQuestions');
    localStorage.removeItem('currentQuizTitle');
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


// --- توابع loadQuestion و selectOption (بدون تغییر در منطق اصلی) ---
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

    isAnswered = false;
    const currentQuestion = questions[currentQuestionIndex];
    questionTextEl.textContent = currentQuestion.text;
    optionsGridEl.innerHTML = '';
    currentQuestion.options.forEach(option => {
        const button = document.createElement('button');
        button.textContent = option;
        button.classList.add('option-btn');
        button.addEventListener('click', () => selectOption(button, currentQuestion));
        optionsGridEl.appendChild(button);
    });
    const progress = ((currentQuestionIndex + 1) / questions.length) * 100;
    progressBarInnerEl.style.width = progress + '%';
    
    // === تغییر: عنوان دکمه را همیشه "Next" قرار می دهیم ===
    checkBtnEl.textContent = 'Next';
    // ====================================================
    checkBtnEl.disabled = true; // همچنان دکمه در ابتدا غیرفعال است

    // به روزرسانی شمارنده سوال
    if (questionCounterEl) {
        questionCounterEl.textContent = `سوال ${currentQuestionIndex + 1} از ${questions.length}`;
    }
}

function selectOption(selectedButton, question) {
    if (isAnswered) return;
    isAnswered = true;
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
    }
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
    quizMainViewEl.style.display = 'none';
    closeQuizBtnEl.style.display = 'none';
    resultsEl.style.display = 'block';

    const firstName = localStorage.getItem('userFirstName') || 'کاربر';
    const lastName = localStorage.getItem('userLastName') || '';
    const userName = `${firstName} ${lastName}`.trim();

    resultsGreetingEl.textContent = `آفرین ${firstName}!`;
    resultsTextEl.textContent = `شما به ${score} از ${questions.length} سوال پاسخ صحیح دادید.`;

    const resultData = {
        userName: userName,
        quizName: currentQuizTitle, // استفاده از عنوان دینامیک (چه از Flask و چه از localStorage)
        score: score,
        totalQuestions: questions.length
    };
    saveResultToServer(resultData);
}

// --- Event Listeners ---
checkBtnEl.addEventListener('click', () => {
    if (!isAnswered) return;
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        loadQuestion();
    } else {
        showResults();
    }
});

restartBtnEl.addEventListener('click', () => { window.location.reload(); });

closeQuizBtnEl.addEventListener('click', (event) => {
    event.preventDefault();
    confirmModalOverlayEl.classList.remove('hidden');
});

confirmNoBtnEl.addEventListener('click', () => {
    confirmModalOverlayEl.classList.add('hidden');
});

// هر دو دکمه خروج/بازگشت به لیست، کاربر را به صفحه /tests بازمی‌گردانند.
confirmYesBtnEl.addEventListener('click', () => { window.location.href = "/tests"; });
returnToListBtnEl.addEventListener('click', () => { window.location.href = "/tests"; });


// بارگذاری اولین سوال هنگام شروع
loadQuestion();