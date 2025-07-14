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
            const quizName = row.querySelector('.quiz-name').textContent.toLowerCase();
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

    // تابع نمایش پیام خالی
    function updateEmptyMessage() {
        const visibleRows = Array.from(resultRows).filter(row => row.style.display !== 'none');
        
        // اگر پیام خالی قبلی وجود دارد، حذف کن
        const existingMessage = document.querySelector('.no-filtered-results');
        if (existingMessage) {
            existingMessage.remove();
        }

        // اگر هیچ نتیجه‌ای نمایش داده نمی‌شود، پیام نمایش بده
        if (visibleRows.length === 0 && (searchInput.value || statusFilter.value !== 'all')) {
            const message = document.createElement('tr');
            message.className = 'no-filtered-results';
            message.innerHTML = `
                <td colspan="6" style="text-align: center; padding: 40px; color: #666;">
                    <div style="font-size: 1.2rem; margin-bottom: 10px;">🔍</div>
                    <div style="font-weight: 600; margin-bottom: 5px;">نتیجه‌ای یافت نشد</div>
                    <div style="font-size: 0.9rem;">لطفاً عبارت جستجو یا فیلتر را تغییر دهید</div>
                </td>
            `;
            resultsTable.appendChild(message);
        }
    }

    // Event listeners
    if (searchInput) {
        searchInput.addEventListener('input', filterResults);
    }

    if (statusFilter) {
        statusFilter.addEventListener('change', filterResults);
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
            const quiz = row.querySelector('.quiz-name').textContent;
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