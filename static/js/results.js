// عملکردهای صفحه نتایج
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('search-input');
    const statusFilter = document.getElementById('status-filter');
    const resultsTable = document.getElementById('results-tbody');
    const resultRows = document.querySelectorAll('.result-row');

    // تابع جستجو
    function filterResults() {
        const searchTerm = searchInput.value.toLowerCase();
        const selectedStatus = statusFilter.value;

        resultRows.forEach(row => {
            const userName = row.querySelector('.user-text').textContent.toLowerCase();
            const quizNameElement = row.querySelector('.quiz-name');
            const quizName = quizNameElement.textContent.toLowerCase();
            const status = row.getAttribute('data-status');

            const matchesSearch = userName.includes(searchTerm) || quizName.includes(searchTerm);
            const matchesStatus = selectedStatus === 'all' || status === selectedStatus;

            if (matchesSearch && matchesStatus) {
                row.style.display = '';
                row.style.opacity = '1';
            } else {
                row.style.display = 'none';
                row.style.opacity = '0';
            }
        });

        updateEmptyMessage();
    }

    // تابع کمکی برای تشخیص آزمون ترکیبی
    function isCombinedTest(quizName) {
        // الگوهای مختلف برای تشخیص آزمون ترکیبی
        const combinedPatterns = [
            /آزمون ترکیبی/,
            /\+/,
            /,/,  // ویرگول برای جدا کردن گرامرها
            /Present.*Past/,
            /Past.*Present/,
            /Simple.*Perfect/,
            /Perfect.*Simple/,
            /Continuous.*Simple/,
            /Simple.*Continuous/
        ];
        
        return combinedPatterns.some(pattern => pattern.test(quizName));
    }

    // تابع استخراج گرامرها از نام آزمون
    function extractGrammars(quizName) {
        const grammarPatterns = [
            'Present Simple', 'Present Continuous', 'Present Perfect',
            'Past Simple', 'Past Continuous', 'Past Perfect',
            'Future Simple', 'Future Continuous', 'Future Perfect'
        ];
        
        // اگر شامل پرانتز است
        if (quizName.includes('(') && quizName.includes(')')) {
            const match = quizName.match(/\(([^)]+)\)/);
            if (match) {
                // ابتدا با ویرگول جدا کن، سپس با +
                const grammarsText = match[1];
                if (grammarsText.includes(',')) {
                    return grammarsText.split(',').map(g => g.trim());
                } else if (grammarsText.includes(' + ')) {
                    return grammarsText.split(' + ');
                } else {
                    return [grammarsText.trim()];
                }
            }
        }
        
        // اگر شامل + است
        if (quizName.includes(' + ')) {
            return quizName.split(' + ');
        }
        
        // اگر شامل ویرگول است
        if (quizName.includes(',')) {
            return quizName.split(',').map(g => g.trim());
        }
        
        // تشخیص از متن
        return grammarPatterns.filter(pattern => quizName.includes(pattern));
    }

    // تابع تبدیل آزمون‌های ترکیبی به دکمه
    function convertCombinedTestsToButtons() {
        resultRows.forEach(row => {
            const quizNameElement = row.querySelector('.quiz-name');
            const quizName = quizNameElement.textContent;
            
            // بررسی اینکه آیا آزمون ترکیبی است
            if (isCombinedTest(quizName)) {
                const grammars = extractGrammars(quizName);
                
                // اگر بیش از یک گرامر پیدا شد
                if (grammars.length > 1) {
                    let fullTitle = quizName;
                    
                    // اگر شامل 'آزمون ترکیبی' نیست، اضافه کن
                    if (!quizName.includes('آزمون ترکیبی')) {
                        fullTitle = `آزمون ترکیبی (${grammars.join(' + ')})`;
                    }
                    
                    // ایجاد دکمه
                    const button = document.createElement('button');
                    button.className = 'combined-test-btn';
                    button.textContent = 'آزمون ترکیبی';
                    button.setAttribute('data-grammars', JSON.stringify(grammars));
                    button.setAttribute('data-full-title', fullTitle);
                    
                    // اضافه کردن event listener
                    button.addEventListener('click', function() {
                        showCombinedTestDetails(grammars, fullTitle);
                    });
                    
                    // جایگزینی متن با دکمه
                    quizNameElement.innerHTML = '';
                    quizNameElement.appendChild(button);
                }
            }
        });
    }

    // تابع نمایش جزئیات آزمون ترکیبی
    function showCombinedTestDetails(grammars, fullTitle) {
        // ایجاد modal
        const modal = document.createElement('div');
        modal.className = 'combined-test-modal-overlay';
        modal.innerHTML = `
            <div class="combined-test-modal">
                <div class="modal-header">
                    <h3>📚 جزئیات آزمون ترکیبی</h3>
                    <button class="close-modal-btn" onclick="this.closest('.combined-test-modal-overlay').remove()">×</button>
                </div>
                <div class="modal-content">
                    <div class="test-info">
                        <h4>${fullTitle}</h4>
                        <p>این آزمون شامل ${grammars.length} گرامر مختلف است:</p>
                    </div>
                    <div class="grammars-list">
                        ${grammars.map((grammar, index) => `
                            <div class="grammar-item">
                                <span class="grammar-number">${index + 1}</span>
                                <span class="grammar-name">${grammar}</span>
                            </div>
                        `).join('')}
                    </div>
                    <div class="test-stats">
                        <p>📊 تعداد گرامرها: ${grammars.length}</p>
                        <p>📝 تخمین سوالات: ${grammars.length * 20} سوال</p>
                        <p>⏱️ زمان تخمینی: ${grammars.length * 10} دقیقه</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="modal-close-btn" onclick="this.closest('.combined-test-modal-overlay').remove()">بستن</button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // بستن modal با کلیک روی overlay
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.remove();
            }
        });
    }

    // فراخوانی تابع تبدیل دکمه‌ها
    convertCombinedTestsToButtons();

    // Event listeners
    if (searchInput) {
        searchInput.addEventListener('input', filterResults);
    }
    
    if (statusFilter) {
        statusFilter.addEventListener('change', filterResults);
    }

    // تابع به‌روزرسانی پیام خالی
    function updateEmptyMessage() {
        const visibleRows = Array.from(resultRows).filter(row => row.style.display !== 'none');
        const emptyMessage = document.querySelector('.no-results');
        
        if (emptyMessage) {
            if (visibleRows.length === 0) {
                emptyMessage.style.display = 'block';
            } else {
                emptyMessage.style.display = 'none';
            }
        }
    }

    // انیمیشن بارگذاری نتایج
    function animateResults() {
        resultRows.forEach((row, index) => {
            row.style.opacity = '0';
            row.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                row.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                row.style.opacity = '1';
                row.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }

    // اجرای انیمیشن پس از بارگذاری صفحه
    setTimeout(animateResults, 300);

    // تابع به‌روزرسانی آمار
    function updateStats() {
        const visibleRows = Array.from(resultRows).filter(row => row.style.display !== 'none');
        const totalResults = visibleRows.length;
        
        // به‌روزرسانی آمار در کارت‌ها (اگر نیاز باشد)
        const totalResultsElement = document.querySelector('.stat-card:first-child .stat-content h3');
        if (totalResultsElement && searchInput.value) {
            totalResultsElement.textContent = totalResults;
        }
    }

    // اضافه کردن عملکرد به جستجو و فیلتر
    const originalFilterResults = filterResults;
    filterResults = function() {
        originalFilterResults();
        updateStats();
    };

    // عملکرد مرتب‌سازی (اختیاری)
    function sortTable(column, type) {
        const rows = Array.from(resultRows);
        const tbody = resultsTable;

        rows.sort((a, b) => {
            let aValue, bValue;

            switch(column) {
                case 'user':
                    aValue = a.querySelector('.user-text').textContent;
                    bValue = b.querySelector('.user-text').textContent;
                    break;
                case 'quiz':
                    aValue = a.querySelector('.quiz-name').textContent;
                    bValue = b.querySelector('.quiz-name').textContent;
                    break;
                case 'score':
                    aValue = parseInt(a.querySelector('.score-number').textContent);
                    bValue = parseInt(b.querySelector('.score-number').textContent);
                    break;
                case 'percentage':
                    aValue = parseFloat(a.querySelector('.percentage-text').textContent);
                    bValue = parseFloat(b.querySelector('.percentage-text').textContent);
                    break;
                case 'date':
                    aValue = new Date(a.querySelector('.date').textContent);
                    bValue = new Date(b.querySelector('.date').textContent);
                    break;
                default:
                    return 0;
            }

            if (type === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });

        // حذف ردیف‌های موجود
        rows.forEach(row => row.remove());

        // اضافه کردن ردیف‌های مرتب شده
        rows.forEach(row => tbody.appendChild(row));
    }

    // اضافه کردن عملکرد مرتب‌سازی به هدر جدول (اختیاری)
    const tableHeaders = document.querySelectorAll('.results-table th');
    tableHeaders.forEach((header, index) => {
        header.style.cursor = 'pointer';
        header.addEventListener('click', () => {
            const columns = ['user', 'quiz', 'score', 'percentage', 'status', 'date'];
            const column = columns[index];
            if (column) {
                // تغییر جهت مرتب‌سازی
                const currentOrder = header.getAttribute('data-order') || 'desc';
                const newOrder = currentOrder === 'desc' ? 'asc' : 'desc';
                
                // حذف کلاس‌های مرتب‌سازی از همه هدرها
                tableHeaders.forEach(h => {
                    h.classList.remove('sort-asc', 'sort-desc');
                    h.removeAttribute('data-order');
                });
                
                // اضافه کردن کلاس مرتب‌سازی به هدر فعلی
                header.classList.add(`sort-${newOrder}`);
                header.setAttribute('data-order', newOrder);
                
                sortTable(column, newOrder);
            }
        });
    });

    // عملکرد چاپ یا اشتراک‌گذاری (اختیاری)
    function shareResults() {
        const visibleRows = Array.from(resultRows).filter(row => row.style.display !== 'none');
        const resultsText = visibleRows.map(row => {
            const user = row.querySelector('.user-text').textContent;
            const quizElement = row.querySelector('.quiz-name');
            const quiz = quizElement.querySelector('.combined-test-btn') ? 
                quizElement.querySelector('.combined-test-btn').getAttribute('data-full-title') : 
                quizElement.textContent;
            const score = row.querySelector('.score-number').textContent;
            const total = row.querySelector('.total-number').textContent;
            const percentage = row.querySelector('.percentage-text').textContent;
            return `${user}: ${score}/${total} (${percentage})`;
        }).join('\n');

        if (navigator.share) {
            navigator.share({
                title: 'نتایج آزمون‌ها',
                text: resultsText,
                url: window.location.href
            });
        } else {
            // کپی به کلیپ‌بورد
            navigator.clipboard.writeText(resultsText).then(() => {
                alert('نتایج در کلیپ‌بورد کپی شد!');
            });
        }
    }

    // اضافه کردن دکمه اشتراک‌گذاری (اختیاری)
    const shareButton = document.createElement('button');
    shareButton.textContent = 'اشتراک‌گذاری';
    shareButton.className = 'share-btn';
    shareButton.style.cssText = `
        background: #28a745;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        margin-left: 10px;
    `;
    shareButton.addEventListener('click', shareResults);

    // اضافه کردن دکمه به header جدول
    const tableActions = document.querySelector('.table-actions');
    if (tableActions) {
        tableActions.appendChild(shareButton);
    }
}); 