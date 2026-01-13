import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]

  validate() {
    const value = this.inputTarget.value.trim()
    const isValid = value.length > 20 && value.startsWith("ck_")

    if (isValid) {
      this.inputTarget.classList.remove("border-red-500")
      this.inputTarget.classList.add("border-black")
      if (this.hasSubmitTarget) {
        this.submitTarget.disabled = false
      }
    } else {
      if (value.length > 0 && !value.startsWith("ck_")) {
        this.inputTarget.classList.add("border-red-500")
        this.inputTarget.classList.remove("border-black")
      }
    }
  }
}
