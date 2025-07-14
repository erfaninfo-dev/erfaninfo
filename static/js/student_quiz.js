// static/js/student_quiz.js

document.addEventListener('DOMContentLoaded', () => {
    const quizCodeInput = document.getElementById('quiz-code-input');
    const submitCodeBtn = document.getElementById('submit-code-btn');
    const codeErrorMessage = document.getElementById('code-error-message');

    const translations = {
        fa: {
            'enter-code-warning': 'لطفاً کد تمرین را وارد کنید.',
            'not-found': 'سوالی یافت نشد.'
        },
        ku: {
            'enter-code-warning': 'تکایە کۆدی خۆت بنووسە!',
            'not-found': 'هیچ پرسیارێک نەدۆزرایەوە.'
        }
    };
    function t(key) {
        return translations[localStorage.getItem('siteLang') || 'fa'][key];
    }

    // منطق ارسال کد و دریافت کوییز
    submitCodeBtn.addEventListener('click', async () => {
        const code = quizCodeInput.value.trim();
        if (!code) {
            codeErrorMessage.textContent = t('enter-code-warning');
            return;
        }
        codeErrorMessage.textContent = ""; // پاک کردن پیام خطای قبلی

        try {
            // ارسال کد به API Flask
            const response = await fetch('/api/get-personalized-quiz', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ code: code })
            });

            const result = await response.json();

            if (result.success) {
                // ذخیره سوالات و عنوان و کد در localStorage برای دسترسی quiz.js
                localStorage.setItem('currentQuizQuestions', JSON.stringify(result.questions));
                localStorage.setItem('currentQuizTitle', result.title);
                localStorage.setItem('currentQuizCode', code); // ذخیره کد آزمون

                // ریدایرکت به صفحه آزمون. quiz.js در آن صفحه، این دیتا را خواهد خواند.
                window.location.href = "/run-personalized-quiz-from-js";
            } else {
                // نمایش پیام خطا از سرور
                if(result.message && result.message.includes('یافت نشد')) {
                    codeErrorMessage.textContent = t('not-found');
                } else {
                    codeErrorMessage.textContent = result.message;
                }
            }
        } catch (error) {
            console.error('Error fetching personalized quiz:', error);
            codeErrorMessage.textContent = "خطا در ارتباط با سرور. لطفا مجددا تلاش کنید.";
        }
    });

    // اضافه کردن قابلیت شروع آزمون با زدن Enter در فیلد کد
    quizCodeInput.addEventListener('keypress', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault(); // جلوگیری از ارسال فرم به روش پیش‌فرض
            submitCodeBtn.click(); // شبیه سازی کلیک روی دکمه
        }
    });
});