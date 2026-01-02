import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "monthlyLabel", "yearlyLabel"]
  static values = { yearly: Boolean }

  connect() {
    this.yearlyValue = false
  }

  toggle() {
    this.yearlyValue = !this.yearlyValue

    if (this.yearlyValue) {
      this.toggleTarget.classList.add("translate-x-8")
      this.yearlyLabelTarget.classList.add("text-black")
      this.yearlyLabelTarget.classList.remove("text-gray-500")
      this.monthlyLabelTarget.classList.add("text-gray-500")
      this.monthlyLabelTarget.classList.remove("text-black")
    } else {
      this.toggleTarget.classList.remove("translate-x-8")
      this.monthlyLabelTarget.classList.add("text-black")
      this.monthlyLabelTarget.classList.remove("text-gray-500")
      this.yearlyLabelTarget.classList.add("text-gray-500")
      this.yearlyLabelTarget.classList.remove("text-black")
    }

    this.dispatch("changed", { detail: { yearly: this.yearlyValue } })
  }
}
