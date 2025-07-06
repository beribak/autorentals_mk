import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["imagePreview", "imageUrl"]

  connect() {
    console.log("Dashboard controller connected")
  }

  previewImage() {
    const url = this.imageUrlTarget.value
    if (url && this.hasImagePreviewTarget) {
      this.imagePreviewTarget.src = url
      this.imagePreviewTarget.style.display = "block"
    }
  }

  confirmDelete(event) {
    const carName = event.target.dataset.carName
    if (!confirm(`Are you sure you want to delete ${carName}? This action cannot be undone.`)) {
      event.preventDefault()
    }
  }
}
