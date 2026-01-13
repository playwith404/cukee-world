import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "settings"]

  connect() {
    this.updateVisibility()
  }

  toggle() {
    this.updateVisibility()
  }

  updateVisibility() {
    if (!this.hasToggleTarget || !this.hasSettingsTarget) return

    const isEnabled = this.toggleTarget.checked

    if (isEnabled) {
      this.settingsTarget.classList.remove("opacity-50")
      // Enable all inputs in settings
      this.settingsTarget.querySelectorAll("input, select, textarea").forEach(input => {
        input.disabled = false
      })
    } else {
      this.settingsTarget.classList.add("opacity-50")
      // Disable all inputs in settings
      this.settingsTarget.querySelectorAll("input, select, textarea").forEach(input => {
        input.disabled = true
      })
    }
  }
}
