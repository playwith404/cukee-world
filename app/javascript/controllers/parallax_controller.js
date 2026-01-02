import { Controller } from "@hotwired/stimulus"

// Gumroad 스타일 마우스 패럴랙스 효과
export default class extends Controller {
  static targets = ["character"]

  connect() {
    this.boundMouseMove = this.handleMouseMove.bind(this)
    document.addEventListener('mousemove', this.boundMouseMove)
  }

  disconnect() {
    document.removeEventListener('mousemove', this.boundMouseMove)
  }

  handleMouseMove(e) {
    const x = (e.clientX / window.innerWidth - 0.5) * 2
    const y = (e.clientY / window.innerHeight - 0.5) * 2

    this.characterTargets.forEach((el) => {
      const speed = parseFloat(el.dataset.speed) || 20
      const rotateSpeed = parseFloat(el.dataset.rotate) || 5

      el.style.transform = `
        translate(${x * speed}px, ${y * speed}px)
        rotate(${x * rotateSpeed}deg)
      `
    })
  }
}
