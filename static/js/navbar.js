document.addEventListener('DOMContentLoaded', function() {
  const hamburger = document.querySelector('.navbar-hamburger');
  const navLinks = document.querySelector('.navbar-links');
  const dropdown = document.querySelector('.dropdown');
  const dropdownMenu = document.querySelector('.dropdown-menu');

  // Hamburger menu toggle
  hamburger.addEventListener('click', function(e) {
    navLinks.classList.toggle('open');
    e.stopPropagation();
  });

  // Close menu on outside click
  document.addEventListener('click', function(e) {
    if (navLinks.classList.contains('open') && !navLinks.contains(e.target) && !hamburger.contains(e.target)) {
      navLinks.classList.remove('open');
    }
  });

  // Dropdown toggle for mobile
  dropdown.addEventListener('click', function(e) {
    if (window.innerWidth <= 900) {
      dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
      e.stopPropagation();
    }
  });

  // Close dropdown on outside click (mobile)
  document.addEventListener('click', function(e) {
    if (window.innerWidth <= 900 && dropdownMenu.style.display === 'block' && !dropdown.contains(e.target)) {
      dropdownMenu.style.display = 'none';
    }
  });

  // Reset dropdown on resize
  window.addEventListener('resize', function() {
    if (window.innerWidth > 900) {
      dropdownMenu.style.display = '';
      navLinks.classList.remove('open');
    }
  });
}); 