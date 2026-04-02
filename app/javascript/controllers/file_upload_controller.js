import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "trigger", "selection", "filename"]

  connect() {
    this.update()
  }

  pick() {
    if (this.triggerTarget.disabled) return
    this.inputTarget.click()
  }

  changed() {
    this.update()
  }

  clear(event) {
    event.preventDefault()
    this.inputTarget.value = ""
    this.update()
  }

  update() {
    const selectedFile = this.inputTarget.files?.[0]
    const hasSelection = Boolean(selectedFile)

    this.filenameTarget.textContent = hasSelection ? selectedFile.name : ""
    this.selectionTarget.classList.toggle("hidden", !hasSelection)
    this.selectionTarget.classList.toggle("flex", hasSelection)

    this.triggerTarget.disabled = hasSelection
    this.triggerTarget.classList.toggle("opacity-50", hasSelection)
    this.triggerTarget.classList.toggle("cursor-not-allowed", hasSelection)
    this.triggerTarget.classList.toggle("hover:bg-slate-200", !hasSelection)
    this.triggerTarget.classList.toggle("dark:hover:bg-slate-700", !hasSelection)
  }
}
