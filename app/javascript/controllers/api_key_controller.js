import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["key", "copyButton"]

  copy() {
    const keyText = this.keyTarget.textContent.trim()

    navigator.clipboard.writeText(keyText).then(() => {
      const originalText = this.copyButtonTarget.textContent
      this.copyButtonTarget.textContent = "복사됨!"
      this.copyButtonTarget.classList.add("bg-char-bean")

      setTimeout(() => {
        this.copyButtonTarget.textContent = originalText
        this.copyButtonTarget.classList.remove("bg-char-bean")
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy:', err)
      // Fallback for older browsers
      this.fallbackCopy(keyText)
    })
  }

  fallbackCopy(text) {
    const textArea = document.createElement("textarea")
    textArea.value = text
    textArea.style.position = "fixed"
    textArea.style.left = "-999999px"
    document.body.appendChild(textArea)
    textArea.focus()
    textArea.select()

    try {
      document.execCommand('copy')
      this.copyButtonTarget.textContent = "복사됨!"
    } catch (err) {
      console.error('Fallback copy failed:', err)
    }

    document.body.removeChild(textArea)
  }
}
