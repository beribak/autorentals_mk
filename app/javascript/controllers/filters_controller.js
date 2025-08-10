// Stimulus controller to toggle visibility of the additional filters section
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "toggleLabel"]

  connect() {
    if (this.hasPanelTarget) {
      const inputs = this.panelTarget.querySelectorAll('input');
      const anyValue = Array.from(inputs).some(i => (i.value || '').trim() !== '');
      if (anyValue) {
        this.show();
      } else {
        this.hide();
      }
    }
  }

  toggle() {
    if (this.panelTarget.hasAttribute('hidden')) {
      this.show();
    } else {
      this.hide();
    }
  }

  show() {
    this.panelTarget.removeAttribute('hidden');
    this.buttonTarget.setAttribute('aria-expanded', 'true');
    this.element.classList.add('filters-expanded');
    if (this.hasToggleLabelTarget) this.toggleLabelTarget.textContent = '➖ ' + this.moreFiltersLabel();
  }

  hide() {
    this.panelTarget.setAttribute('hidden', '');
    this.buttonTarget.setAttribute('aria-expanded', 'false');
    this.element.classList.remove('filters-expanded');
    if (this.hasToggleLabelTarget) this.toggleLabelTarget.textContent = '➕ ' + this.moreFiltersLabel();
  }

  moreFiltersLabel() {
    // Fallback label in case translation isn't injected server-side
    return this.buttonTarget.dataset.label || 'Additional filters';
  }
}
