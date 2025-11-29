// static/js/combined_tests.js

document.addEventListener('DOMContentLoaded', () => {
    const testModeRadios = document.querySelectorAll('input[name="test-mode"]');
    const combinedTestControls = document.querySelector('.combined-test-controls');
    const quizCardContainer = document.querySelector('.quiz-card-container');
    const grammarCheckboxes = document.querySelector('.grammar-checkboxes');
    const selectAllBtn = document.querySelector('.select-all-btn');
    const deselectAllBtn = document.querySelector('.deselect-all-btn');
    const startCombinedTestBtn = document.querySelector('.start-combined-test-btn');
    const orderRadios = document.querySelectorAll('input[name="combined-order"]');
    
    let availableGrammars = [];
    let selectedGrammars = new Set();

    // Initialize the page
    initializeCombinedTests();

    // Event listeners for mode switching
    testModeRadios.forEach(radio => {
        radio.addEventListener('change', handleModeChange);
    });

    // Event listeners for combined test controls
    selectAllBtn.addEventListener('click', selectAllGrammars);
    deselectAllBtn.addEventListener('click', deselectAllGrammars);
    startCombinedTestBtn.addEventListener('click', startCombinedTest);

    function initializeCombinedTests() {
        // Get available grammars from the server with order_num
        fetch('/api/get-available-grammars')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    availableGrammars = data.grammars;
                    populateGrammarCheckboxes();
                }
            })
            .catch(error => {
                console.error('Error fetching grammars:', error);
                // Fallback to extracting from DOM
                const quizCards = document.querySelectorAll('.quiz-card:not(.student-quiz-card)');
                availableGrammars = [];

                quizCards.forEach(card => {
                    const category = card.dataset.category;
                    if (category) {
                        availableGrammars.push({ name: category, order_num: 999 });
                    }

                    const subButtons = card.querySelectorAll('.sub-button');
                    subButtons.forEach(button => {
                        const href = button.getAttribute('href');
                        if (href && href.startsWith('/test/')) {
                            const grammarName = decodeURIComponent(href.replace('/test/', ''));
                            if (!availableGrammars.find(g => g.name === grammarName)) {
                                availableGrammars.push({ name: grammarName, order_num: 999 });
                            }
                        }
                    });
                });
                populateGrammarCheckboxes();
            });
    }

    function handleModeChange(event) {
        const mode = event.target.value;
        
        if (mode === 'single') {
            // Show quiz cards, hide combined controls
            combinedTestControls.style.display = 'none';
            quizCardContainer.classList.remove('combined-mode');
            // در حالت تکی کارت زبان‌آموز را نمایش بده
            const studentCard = document.querySelector('.quiz-card.student-quiz-card');
            if (studentCard) studentCard.style.display = '';
        } else if (mode === 'combined') {
            // Hide quiz cards, show combined controls
            combinedTestControls.style.display = 'block';
            quizCardContainer.classList.add('combined-mode');
            // در حالت ترکیبی کارت زبان‌آموز هم پنهان می‌شود
            const studentCard = document.querySelector('.quiz-card.student-quiz-card');
            if (studentCard) studentCard.style.display = 'none';
            
            // Close any expanded cards
            const expandedCard = document.querySelector('.quiz-card.expanded');
            if (expandedCard) {
                const expandBtn = expandedCard.querySelector('.expand-card-btn');
                if (expandBtn) {
                    expandBtn.click();
                }
            }
        }
    }

    function populateGrammarCheckboxes() {
        grammarCheckboxes.innerHTML = '';
        
        // Sort grammars by order_num
        const sortedGrammars = availableGrammars.sort((a, b) => a.order_num - b.order_num);
        
        sortedGrammars.forEach(grammar => {
            const checkboxItem = document.createElement('div');
            checkboxItem.className = 'grammar-checkbox-item';
            
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.id = `grammar-${grammar.name.replace(/\s+/g, '-').toLowerCase()}`;
            checkbox.value = grammar.name;
            
            const label = document.createElement('label');
            label.htmlFor = checkbox.id;
            label.textContent = grammar.name;
            
            checkboxItem.appendChild(checkbox);
            checkboxItem.appendChild(label);
            
            // Add click event to the entire item
            checkboxItem.addEventListener('click', (e) => {
                // If clicked directly on checkbox, let the checkbox handle it
                if (e.target === checkbox) {
                    return;
                }
                // Toggle checkbox state for clicks on other parts
                checkbox.checked = !checkbox.checked;
                handleCheckboxChange(checkbox);
            });
            
            // Add click event specifically to label
            label.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                checkbox.checked = !checkbox.checked;
                handleCheckboxChange(checkbox);
            });
            
            // Add change event to checkbox (this handles direct checkbox clicks)
            checkbox.addEventListener('change', () => handleCheckboxChange(checkbox));
            
            grammarCheckboxes.appendChild(checkboxItem);
        });
    }

    function handleCheckboxChange(checkbox) {
        const grammar = checkbox.value;
        
        if (checkbox.checked) {
            selectedGrammars.add(grammar);
        } else {
            selectedGrammars.delete(grammar);
        }
        
        updateStartButton();
    }

    function selectAllGrammars() {
        const checkboxes = grammarCheckboxes.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.checked = true;
            selectedGrammars.add(checkbox.value);
        });
        updateStartButton();
    }

    function deselectAllGrammars() {
        const checkboxes = grammarCheckboxes.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
            selectedGrammars.delete(checkbox.value);
        });
        updateStartButton();
    }

    function updateStartButton() {
        if (selectedGrammars.size > 0) {
            startCombinedTestBtn.disabled = false;
            startCombinedTestBtn.textContent = `شروع آزمون ترکیبی (${selectedGrammars.size} گرامر)`;
        } else {
            startCombinedTestBtn.disabled = true;
            startCombinedTestBtn.textContent = 'شروع آزمون ترکیبی';
        }
    }

    function startCombinedTest() {
        if (selectedGrammars.size === 0) {
            alert('لطفاً حداقل یک گرامر را انتخاب کنید.');
            return;
        }

        // Show loading state
        startCombinedTestBtn.disabled = true;
        startCombinedTestBtn.textContent = 'در حال بارگذاری...';

        // Prepare the data for the API
        const testData = {
            grammars: Array.from(selectedGrammars),
            test_type: 'combined',
            order_mode: (document.querySelector('input[name="combined-order"]:checked')?.value) || 'grammar'
        };

        // Call the API to get combined test questions
        fetch('/api/get-combined-test', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(testData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Store the test data in sessionStorage for the quiz page
                sessionStorage.setItem('combinedTestData', JSON.stringify({
                    questions: data.questions,
                    selectedGrammars: Array.from(selectedGrammars),
                    testType: 'combined',
                    title: `آزمون ترکیبی (${Array.from(selectedGrammars).join(' + ')})`,
                    orderMode: testData.order_mode
                }));
                
                // Redirect to the quiz page (same as regular tests)
                window.location.href = '/test/combined';
            } else {
                throw new Error(data.message || 'خطا در بارگذاری آزمون');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('خطا در بارگذاری آزمون ترکیبی. لطفاً دوباره تلاش کنید.');
            
            // Reset button state
            startCombinedTestBtn.disabled = false;
            updateStartButton();
        });
    }
}); 