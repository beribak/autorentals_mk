// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
  // Mobile navigation toggle
  const mobileToggle = document.createElement('div');
  mobileToggle.className = 'nav-mobile-toggle';
  mobileToggle.innerHTML = '<span></span><span></span><span></span>';
  
  const navContainer = document.querySelector('.nav-container');
  const navMenu = document.querySelector('.nav-menu');
  
  if (navContainer && navMenu) {
    navContainer.appendChild(mobileToggle);
    
    mobileToggle.addEventListener('click', function() {
      navMenu.classList.toggle('active');
      this.classList.toggle('active');
    });
    
    // Close mobile menu when clicking on a link
    navMenu.addEventListener('click', function(e) {
      if (e.target.matches('.nav-link')) {
        navMenu.classList.remove('active');
        mobileToggle.classList.remove('active');
      }
    });
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
      if (!navContainer.contains(e.target)) {
        navMenu.classList.remove('active');
        mobileToggle.classList.remove('active');
      }
    });
  }
  
  // Highlight active nav link based on current page
  const currentPath = window.location.pathname;
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPath || (currentPath === '/' && href === '/')) {
      link.classList.add('active');
    }
  });
  
  // Smooth scroll for hero CTA
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href');
      const targetElement = document.querySelector(targetId);
      
      if (targetElement) {
        const offsetTop = targetElement.offsetTop - 70; // Account for fixed navbar
        window.scrollTo({
          top: offsetTop,
          behavior: 'smooth'
        });
      }
    });
  });
});

// Add mobile navigation styles
const mobileNavStyles = `
  .nav-mobile-toggle.active span:nth-child(1) {
    transform: rotate(45deg) translate(5px, 5px);
  }
  
  .nav-mobile-toggle.active span:nth-child(2) {
    opacity: 0;
  }
  
  .nav-mobile-toggle.active span:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -6px);
  }
`;

const styleSheet = document.createElement('style');
styleSheet.textContent = mobileNavStyles;
document.head.appendChild(styleSheet);
