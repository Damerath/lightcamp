import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
  }

  toggle(event) {
    event.stopPropagation()

    const isOpening = this.menuTarget.classList.contains("hidden")

    if (isOpening) {
      this.menuTarget.classList.remove("hidden")
      this.iconTarget.classList.remove("text-slate-300")
      this.iconTarget.classList.add("text-red-500")
    } else {
      this.menuTarget.classList.add("hidden")
      this.iconTarget.classList.remove("text-red-500")
      this.iconTarget.classList.add("text-slate-300")
    }
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this.iconTarget.classList.remove("text-red-500")
      this.iconTarget.classList.add("text-slate-300")
    }
  }
}