import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel"]

  connect() {
    this.keydownHandler = (event) => {
      if (event.key === "Escape") this.close()
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.keydownHandler)
    document.body.classList.remove("overflow-hidden")
  }

  open() {
    this.backdropTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.keydownHandler)

    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove("opacity-0")
      this.backdropTarget.classList.add("opacity-100")
      this.panelTarget.classList.remove("translate-x-full")
      this.panelTarget.classList.add("translate-x-0")
    })
  }

  close() {
    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")
    this.panelTarget.classList.remove("translate-x-0")
    this.panelTarget.classList.add("translate-x-full")
    document.removeEventListener("keydown", this.keydownHandler)

    setTimeout(() => {
      this.backdropTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }, 180)
  }

  closeFromBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }
}
