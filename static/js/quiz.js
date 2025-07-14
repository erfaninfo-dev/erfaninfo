// static/js/quiz.js

let score = 0;
let currentQuestionIndex = 0;
let isAnswered = false;

// متغیر سراسری questions.
// این متغیر حالا از 'window.initialQuizQuestions' مقداردهی اولیه می‌شود که توسط Flask تنظیم شده است.
// اگر 'window.initialQuizQuestions' وجود نداشته باشد (مثلا برای آزمون های شخصی سازی شده)،
// آن را به یک آرایه خالی مقداردهی می کنیم.
let questions = window.initialQuizQuestions || [];

let personalQuizCode = null;


let currentQuizTitle = document.title.replace('آزمون: ', ''); // عنوان اولیه از Flask


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
        const lang = localStorage.getItem('siteLang') || 'fa';
        if (lang === 'ku') {
            questionCounterEl.textContent = `پرسیار ${currentQuestionIndex + 1} لە ${questions.length}`;
        } else {
            questionCounterEl.textContent = `سوال ${currentQuestionIndex + 1} از ${questions.length}`;
        }
    }

    // --- نمایش عنوان گرامر فعلی در عنوان صفحه و هدر آزمون ---
    if (currentQuestion.content) {
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
    
    // دکمه گزارش همیشه فعال می‌ماند - حتی بعد از پاسخ دادن
    // if (reportQuestionBtnEl) {
    //     reportQuestionBtnEl.disabled = true;
    // }
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

    // دریافت نام کامل کاربر از localStorage
    const userFullName = localStorage.getItem('userFullName') || 'کاربر';

    // نمایش ایموجی اگر امتیاز بیشتر از 30 بود
    let emojiHtml = '';
    if (score > 30) {
        emojiHtml = '<div style="font-size:2.5rem; text-align:center;">🏆</div>';
    }

    // نمایش نام کاربر و نتیجه
    resultsGreetingEl.innerHTML = `${emojiHtml}<span>آفرین ${userFullName}!`;
    resultsTextEl.textContent = `شما به ${score} از ${questions.length} سوال پاسخ صحیح دادید.`;

    // استفاده از تابع کمکی
    const quizName = getQuizName();

    const resultData = {
        user_name: userFullName,
        quiz_name: quizName,
        score: score,
        total_questions: questions.length
    };
    saveResultToServer(resultData);
    personalQuizCode = null;
    localStorage.removeItem('currentQuizCode');
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
function showReportModal() {
    // نمایش Modal گزارش
    document.getElementById('report-modal').classList.remove('hidden');
    // پاک کردن انتخاب قبلی
    document.getElementById('report-reason').value = '';
}

function closeReportModal() {
    // بستن Modal گزارش
    document.getElementById('report-modal').classList.add('hidden');
}

async function submitReport() {
    if (!questions || currentQuestionIndex >= questions.length) {
        return;
    }
    
    const currentQuestion = questions[currentQuestionIndex];
    
    // دریافت دلیل گزارش
    const reportReasonSelect = document.getElementById('report-reason');
    const reportReason = reportReasonSelect.value;
    if (!reportReason) {
        alert('لطفاً دلیل گزارش را انتخاب کنید');
        return;
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
        
        const reportData = {
            question_id: currentQuestion.id,
            question_text: currentQuestion.text,
            options: currentQuestion.options,
            correct_answer: currentQuestion.answer,
            quiz_name: quizName,
            content: contentValue, // مقدار content برابر با quizName
            question_type: questionTypeValue, // مقدار دقیق question_type طبق منطق جدید
            quiz_type: quizType,
            reported_reason: persianReason,  // ارسال متن فارسی به جای enum
            user_name: userFullName // اضافه کردن نام کاربر
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
            alert(result.message);
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
    if (localStorage.getItem('currentQuizTitle')) {
        return 'personal';
    } else {
        return 'general';
    }
}

// تابع کمکی برای دریافت quiz_name
function getQuizName() {
    if (personalQuizCode) {
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