// لود کردن گزارشات
async function loadReports() {
    try {
        const statusFilter = document.getElementById('status-filter').value;
        const quizTypeFilter = document.getElementById('quiz-type-filter').value;
        
        const params = new URLSearchParams();
        if (statusFilter !== 'all') {
            params.append('status', statusFilter);
        }
        if (quizTypeFilter !== 'all') {
            params.append('quiz_type', quizTypeFilter);
        }
        
        const response = await fetch(`/api/admin/wrong-questions?${params.toString()}`);
        const data = await response.json();
        
        if (data.success) {
            displayReports(data.reports);
            updateStats(data.stats);
        }
    } catch (error) {
        console.error('Error loading reports:', error);
    }
}

// نمایش گزارشات
function displayReports(reports) {
    const tbody = document.getElementById('reports-tbody');
    tbody.innerHTML = '';
    
    reports.forEach(report => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${new Date(report.created_at).toLocaleDateString('fa-IR')}</td>
            <td>${report.question_text.substring(0, 50)}...</td>
            <td>${report.content || '-'}</td>
            <td>${getQuizTypeText(report.question_type)}</td>
            <td>${getReportReasonText(report.reported_reason)}</td>
            <td>${report.user_name || '-'}</td>
            <td><span class="status-${report.status}">${getStatusText(report.status)}</span></td>
            <td>
                <div class="action-buttons">
                    <button class="action-btn btn-reviewed" onclick="updateStatus(${report.id}, 'reviewed')">بررسی شد</button>
                    <button class="action-btn btn-fixed" onclick="updateStatus(${report.id}, 'fixed')">اصلاح شد</button>
                    <button class="action-btn btn-rejected" onclick="updateStatus(${report.id}, 'rejected')">رد شد</button>
                    <button class="action-btn btn-edit" onclick="editQuestion(${report.id}, '${report.question_type}')">ویرایش</button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// به‌روزرسانی آمار
function updateStats(stats) {
    document.getElementById('total-reports').textContent = stats.total || 0;
    document.getElementById('pending-reports').textContent = stats.pending || 0;
    document.getElementById('today-reports').textContent = stats.today || 0;
}

// فیلتر کردن گزارشات
function filterReports() {
    loadReports();
}

// تبدیل دلیل گزارش به متن فارسی
function getReportReasonText(reason) {
    return reason || 'سایر';
}

// به‌روزرسانی وضعیت
async function updateStatus(reportId, newStatus) {
    try {
        const response = await fetch('/api/admin/update-question-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                question_id: reportId,
                status: newStatus
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            loadReports(); // بارگذاری مجدد
        } else {
            alert('خطا در به‌روزرسانی وضعیت');
        }
    } catch (error) {
        console.error('Error updating status:', error);
        alert('خطا در ارتباط با سرور');
    }
}

// تبدیل وضعیت به متن فارسی
function getStatusText(status) {
    const statusMap = {
        'pending': 'در انتظار',
        'reviewed': 'بررسی شده',
        'fixed': 'اصلاح شده',
        'rejected': 'رد شده'
    };
    return statusMap[status] || status;
}

// تبدیل نوع آزمون به متن فارسی
function getQuizTypeText(quizType) {
    const typeMap = {
        'general': 'عمومی',
        'personal': 'شخصی'
    };
    return typeMap[quizType] || quizType;
}

// تابع باز کردن Modal ویرایش
async function editQuestion(reportId, questionType) {
    try {
        // دریافت اطلاعات سوال
        const response = await fetch(`/api/admin/get-question/${reportId}`);
        const data = await response.json();
        
        if (data.success) {
            // پر کردن فرم
            document.getElementById('edit-question-id').value = reportId;
            document.getElementById('edit-question-type').value = questionType;
            document.getElementById('edit-question-text').value = data.question.question_text;
            document.getElementById('edit-option1').value = data.question.option1 || '';
            document.getElementById('edit-option2').value = data.question.option2 || '';
            document.getElementById('edit-option3').value = data.question.option3 || '';
            document.getElementById('edit-option4').value = data.question.option4 || '';
            document.getElementById('edit-correct-answer').value = data.question.correct_answer || '';
            
            // نمایش Modal
            document.getElementById('edit-question-modal').classList.remove('hidden');
        } else {
            alert('خطا در دریافت اطلاعات سوال: ' + data.message);
        }
    } catch (error) {
        console.error('Error loading question:', error);
        alert('خطا در ارتباط با سرور');
    }
}

// تابع بستن Modal
function closeEditModal() {
    document.getElementById('edit-question-modal').classList.add('hidden');
    document.getElementById('edit-question-form').reset();
}

// تابع ذخیره تغییرات
function setupEditForm() {
    const form = document.getElementById('edit-question-form');
    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = {
                question_id: document.getElementById('edit-question-id').value,
                question_type: document.getElementById('edit-question-type').value,
                question_text: document.getElementById('edit-question-text').value,
                option1: document.getElementById('edit-option1').value,
                option2: document.getElementById('edit-option2').value,
                option3: document.getElementById('edit-option3').value,
                option4: document.getElementById('edit-option4').value,
                correct_answer: document.getElementById('edit-correct-answer').value
            };
            
            try {
                const response = await fetch('/api/admin/edit-question', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(formData)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert('سوال با موفقیت ویرایش شد');
                    closeEditModal();
                    loadReports(); // بارگذاری مجدد
                } else {
                    alert('خطا در ویرایش سوال: ' + result.message);
                }
            } catch (error) {
                console.error('Error editing question:', error);
                alert('خطا در ارتباط با سرور');
            }
        });
    }
}

// بستن Modal با کلیک خارج از آن
function setupModalClose() {
    const modal = document.getElementById('edit-question-modal');
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
    }
}

// تنظیمات اولیه
document.addEventListener('DOMContentLoaded', function() {
    // اگر در صفحه گزارشات هستیم
    if (document.getElementById('reports-tbody')) {
        loadReports();
        setupEditForm();
        setupModalClose();
    }
}); 