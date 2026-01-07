import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]

  connect() {
    const highlighted = this.rowTargets.find((row) => row.dataset.highlight === "true")
    if (!highlighted) return

    highlighted.classList.add("ticket-row--pulse")
    const flashClass = highlighted.dataset.flashClass
    if (flashClass) {
      highlighted.classList.add(flashClass)
    }
    highlighted.scrollIntoView({ behavior: "smooth", block: "center" })

    setTimeout(() => {
      highlighted.classList.remove("ticket-row--pulse")
      if (flashClass) {
        highlighted.classList.remove(flashClass)
      }
    }, 650)
  }
}
