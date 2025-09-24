import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-hide flash message after 5 seconds
    this.timeout = setTimeout(() => {
      this.hide()
    }, 5000)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close() {
    this.hide()
  }

  hide() {
    this.element.style.animation = "fadeOut 0.3s ease-out"
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }
}