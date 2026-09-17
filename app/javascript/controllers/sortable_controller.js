import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = { url: String }

  dragStart(event) {
    this.draggedItem = event.currentTarget.closest("[data-sortable-target='item']")
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", this.draggedItem.dataset.sortableIdValue)
    this.draggedItem.classList.add("opacity-50")
  }

  dragOver(event) {
    event.preventDefault()
    const targetItem = event.target.closest("[data-sortable-target='item']")

    if (!this.draggedItem || !targetItem || targetItem === this.draggedItem) return

    const insertBefore = event.clientY < targetItem.getBoundingClientRect().top + targetItem.offsetHeight / 2
    this.element.insertBefore(this.draggedItem, insertBefore ? targetItem : targetItem.nextSibling)
  }

  drop(event) {
    event.preventDefault()
  }

  async dragEnd() {
    if (!this.draggedItem) return

    this.draggedItem.classList.remove("opacity-50")
    this.draggedItem = null

    const response = await fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ ids: this.itemTargets.map((item) => item.dataset.sortableIdValue) })
    })

    if (!response.ok) window.location.reload()
  }
}
