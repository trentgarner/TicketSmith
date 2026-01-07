import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.classList.remove("show")
      this.element.addEventListener("transitionend", () => this.element.remove(), { once: true })
    }, 3000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
