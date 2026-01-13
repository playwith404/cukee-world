import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    type: { type: String, default: "bar" }
  }

  connect() {
    // Chart rendering is done inline in the view for simplicity
    // This controller can be extended to use Chart.js or similar libraries
  }
}
