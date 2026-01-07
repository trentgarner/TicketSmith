import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dragStart(event) {
    this.draggedCard = event.currentTarget
    this.draggedCardParent = this.draggedCard.parentElement
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", this.draggedCard.dataset.ticketId)
  }

  allowDrop(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
  }

  drop(event) {
    event.preventDefault()
    const column = event.currentTarget
    const lane = column.querySelector("[data-board-lane]")
    const status = column.dataset.boardStatus
    const updateUrl = this.draggedCard?.dataset.updateUrl

    if (!lane || !this.draggedCard || !updateUrl) {
      return
    }

    lane.appendChild(this.draggedCard)
    this.updateCardStatusStyles(this.draggedCard, status)
    this.flashCard(this.draggedCard, status)
    this.updateStatus(updateUrl, status)
  }

  updateStatus(url, status) {
    const token = document.querySelector('meta[name="csrf-token"]').content
    const body = new URLSearchParams()
    body.append("ticket[status]", status)

    fetch(url, {
      method: "PATCH",
      headers: { "X-CSRF-Token": token, "Accept": "application/json" },
      body
    }).then((response) => {
      if (!response.ok && this.draggedCardParent) {
        this.draggedCardParent.appendChild(this.draggedCard)
        return
      }
      if (response.ok && window.Turbo) {
        setTimeout(() => {
          const refreshUrl = this.element.dataset.refreshUrl
          window.Turbo.visit(refreshUrl || window.location.href, { frame: "tickets_view" })
        }, 220)
      }
    }).catch(() => {
      if (this.draggedCardParent) {
        this.draggedCardParent.appendChild(this.draggedCard)
      }
    })
  }

  flashCard(card, status) {
    const normalized = status.toString().toLowerCase().replaceAll(" ", "_")
    const classes = {
      open: "board-card--flash-secondary",
      in_progress: "board-card--flash-warning",
      wip: "board-card--flash-warning",
      resolved: "board-card--flash-success"
    }
    const flashClass = classes[normalized] || "board-card--flash-secondary"

    card.classList.add("board-card--flash", flashClass)
    setTimeout(() => {
      card.classList.remove("board-card--flash", flashClass)
    }, 300)
  }

  updateCardStatusStyles(card, status) {
    const normalized = status.toString().toLowerCase().replaceAll(" ", "_")
    const badgeClasses = {
      open: "secondary",
      in_progress: "warning",
      wip: "warning",
      resolved: "success"
    }
    const badge = badgeClasses[normalized] || "secondary"

    card.classList.remove("board-card--secondary", "board-card--warning", "board-card--success")
    card.classList.add(`board-card--${badge}`)
  }
}
