import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Close mobile menu when clicking outside
    this.outsideClickHandler = this.handleOutsideClick.bind(this)
    document.addEventListener('click', this.outsideClickHandler)
  }

  disconnect() {
    document.removeEventListener('click', this.outsideClickHandler)
  }

  toggleMenu(event) {
    event.preventDefault()
    const toggle = event.currentTarget
    this.menuTarget.classList.toggle('active')
    toggle.classList.toggle('active')
  }

  closeMenu() {
    const toggle = this.element.querySelector('.nav-mobile-toggle')
    this.menuTarget.classList.remove('active')
    if (toggle) {
      toggle.classList.remove('active')
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.closeMenu()
    }
  }

  // Handle clicks on nav links to close mobile menu
  menuTargetConnected() {
    this.menuTarget.addEventListener('click', (e) => {
      if (e.target.matches('.nav-link')) {
        this.closeMenu()
      }
    })
  }
}
