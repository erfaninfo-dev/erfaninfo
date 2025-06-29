// Video lightbox modal logic
const modal = document.getElementById('video-modal');
const modalContent = modal.querySelector('.modal-content');
const closeModal = modal.querySelector('.close-modal');
const iframe = modal.querySelector('iframe');

// Open modal on video-thumb click
Array.from(document.querySelectorAll('.video-thumb')).forEach(thumb => {
  thumb.addEventListener('click', function() {
    const videoUrl = this.getAttribute('data-video');
    iframe.src = videoUrl + '?autoplay=1';
    modal.style.display = 'flex';
    setTimeout(() => { modal.style.opacity = 1; }, 10);
  });
});

// Close modal on close button or outside click
closeModal.addEventListener('click', closeVideoModal);
modal.addEventListener('click', function(e) {
  if (e.target === modal) closeVideoModal();
});
function closeVideoModal() {
  modal.style.opacity = 0;
  setTimeout(() => {
    modal.style.display = 'none';
    iframe.src = '';
  }, 200);
} 