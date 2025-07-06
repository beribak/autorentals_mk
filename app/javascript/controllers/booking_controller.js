import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "endDate", "availabilityStatus", "priceSummary", "duration", "totalPrice", "dailyRate", "submitButton"]

  connect() {
    this.carId = this.element.dataset.carId || window.location.pathname.split('/')[2]
    this.pricePerDay = parseFloat(this.dailyRateTarget.textContent.replace('$', ''))
    
    // Check if dates are pre-filled and calculate price immediately
    setTimeout(() => {
      const startDate = this.startDateTarget.value
      const endDate = this.endDateTarget.value
      
      if (startDate && endDate) {
        this.calculatePrice()
        // Also show price summary immediately for pre-filled dates
        this.calculatePriceOnly(startDate, endDate)
      }
    }, 100)
  }

  // Calculate price without availability check
  calculatePriceOnly(startDate, endDate) {
    const start = new Date(startDate)
    const end = new Date(endDate)
    const duration = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1
    const totalPrice = this.pricePerDay * duration
    
    if (duration > 0) {
      this.durationTarget.textContent = `${duration} day${duration > 1 ? 's' : ''}`
      this.totalPriceTarget.textContent = `$${totalPrice.toFixed(2)}`
      this.priceSummaryTarget.style.display = 'block'
      this.enableSubmitButton()
    }
  }

  calculatePrice() {
    const startDate = this.startDateTarget.value
    const endDate = this.endDateTarget.value

    if (startDate && endDate) {
      // Always calculate price first
      this.calculatePriceOnly(startDate, endDate)
      
      // Then check availability (but don't disable button if it fails)
      this.checkAvailability(startDate, endDate)
    } else {
      this.hidePriceSummary()
      this.disableSubmitButton()
    }
  }

  async checkAvailability(startDate, endDate) {
    try {
      const response = await fetch(`/check_availability?car_id=${this.carId}&start_date=${startDate}&end_date=${endDate}`)
      const data = await response.json()

      if (data.available) {
        this.showAvailableStatus(data)
      } else {
        this.showUnavailableStatus()
      }
    } catch (error) {
      console.error('Error checking availability:', error)
      this.showErrorStatus()
    }
    // Note: We don't disable the button here anymore - let the user proceed
  }

  showAvailableStatus(data) {
    this.availabilityStatusTarget.innerHTML = `
      <div class="availability-message available">
        <span class="status-icon">✅</span>
        <span>Car is available for your selected dates!</span>
      </div>
    `
    this.availabilityStatusTarget.style.display = 'block'
  }

  showUnavailableStatus() {
    this.availabilityStatusTarget.innerHTML = `
      <div class="availability-message unavailable">
        <span class="status-icon">⚠️</span>
        <span>This car may already be booked for some of these dates. You can still submit your request and we'll contact you with alternatives.</span>
      </div>
    `
    this.availabilityStatusTarget.style.display = 'block'
  }

  showErrorStatus() {
    this.availabilityStatusTarget.innerHTML = `
      <div class="availability-message error">
        <span class="status-icon">ℹ️</span>
        <span>Unable to check availability right now. You can still submit your booking request.</span>
      </div>
    `
    this.availabilityStatusTarget.style.display = 'block'
  }

  showPriceSummary(data) {
    this.durationTarget.textContent = `${data.duration} day${data.duration > 1 ? 's' : ''}`
    this.totalPriceTarget.textContent = `$${data.total_price.toFixed(2)}`
    this.priceSummaryTarget.style.display = 'block'
  }

  hidePriceSummary() {
    this.priceSummaryTarget.style.display = 'none'
    this.availabilityStatusTarget.style.display = 'none'
  }

  enableSubmitButton() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.classList.remove('disabled')
    }
  }

  disableSubmitButton() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.classList.add('disabled')
    }
  }

  // Add form validation to enable button when all required fields are filled
  validateForm() {
    const startDate = this.startDateTarget.value
    const endDate = this.endDateTarget.value
    const pickupLocation = this.element.querySelector('[name="booking[pickup_location]"]')?.value
    const firstName = this.element.querySelector('[name="customer[first_name]"]')?.value
    const lastName = this.element.querySelector('[name="customer[last_name]"]')?.value
    const email = this.element.querySelector('[name="customer[email]"]')?.value
    const phone = this.element.querySelector('[name="customer[phone]"]')?.value

    const allFieldsFilled = startDate && endDate && pickupLocation && firstName && lastName && email && phone
    
    if (allFieldsFilled && startDate && endDate) {
      // If all fields are filled and we have dates, enable the button
      this.enableSubmitButton()
    }
  }

  // Add this method to be called on form input changes
  handleFormInput() {
    this.validateForm()
  }
}
