import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    const row = this.element
    row.classList.add("ticket-row--pulse")
  }
}
