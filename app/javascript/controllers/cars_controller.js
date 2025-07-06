// Cars page functionality
document.addEventListener('DOMContentLoaded', function() {
  // Smooth scrolling for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Add loading states to filter form
  const filterForm = document.querySelector('.filters-form');
  if (filterForm) {
    filterForm.addEventListener('submit', function() {
      const submitBtn = this.querySelector('[type="submit"]');
      if (submitBtn) {
        submitBtn.textContent = 'Filtering...';
        submitBtn.disabled = true;
      }
      
      // Add loading class to cars grid
      const carsGrid = document.querySelector('.cars-grid');
      if (carsGrid) {
        carsGrid.classList.add('loading');
      }
    });
  }

  // Reset loading states after turbo frame loads
  document.addEventListener('turbo:frame-load', function() {
    const submitBtn = document.querySelector('.filters-form [type="submit"]');
    if (submitBtn) {
      submitBtn.textContent = 'Filter';
      submitBtn.disabled = false;
    }
    
    const carsGrid = document.querySelector('.cars-grid');
    if (carsGrid) {
      carsGrid.classList.remove('loading');
    }
  });

  // Add intersection observer for animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };

  const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.animationDelay = `${Math.random() * 0.3}s`;
        entry.target.classList.add('animate-in');
      }
    });
  }, observerOptions);

  // Observe car cards for animations
  document.querySelectorAll('.car-card, .car-preview-card, .feature-card').forEach(card => {
    observer.observe(card);
  });

  // Car card hover effects
  document.querySelectorAll('.car-card, .car-preview-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
      this.style.transform = 'translateY(-8px) scale(1.02)';
    });
    
    card.addEventListener('mouseleave', function() {
      this.style.transform = 'translateY(0) scale(1)';
    });
  });
});

// Navigation scroll effect
window.addEventListener('scroll', function() {
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    if (window.scrollY > 50) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }
});

// Filter input enhancements
document.addEventListener('input', function(e) {
  if (e.target.matches('.filter-input')) {
    // Add visual feedback for active filters
    if (e.target.value.trim()) {
      e.target.style.borderColor = 'var(--accent-primary)';
      e.target.style.boxShadow = '0 0 0 3px var(--shadow-light)';
    } else {
      e.target.style.borderColor = 'var(--border-color)';
      e.target.style.boxShadow = 'none';
    }
  }
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
  .animate-in {
    animation: slideInUp 0.6s ease-out forwards;
  }
  
  @keyframes slideInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .car-card, .car-preview-card {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  }
  
  .loading .car-card {
    opacity: 0.7;
    pointer-events: none;
  }
`;
document.head.appendChild(style);
