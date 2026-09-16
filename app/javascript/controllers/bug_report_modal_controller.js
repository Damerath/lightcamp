import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "fileInput", "preview", "previewFilename", "pageUrl", "browserDetails", "viewport"]

  connect() {
    this.keydownHandler = (event) => {
      if (event.key === "Escape") this.close()
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.keydownHandler)
  }

  open() {
    this.pageUrlTarget.value = window.location.href
    this.browserDetailsTarget.value = navigator.userAgent
    this.viewportTarget.value = `${window.innerWidth} × ${window.innerHeight}`
    this.backdropTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.keydownHandler)

    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove("opacity-0")
      this.backdropTarget.classList.add("opacity-100")
      this.panelTarget.classList.remove("opacity-0", "translate-y-4", "scale-95")
      this.panelTarget.classList.add("opacity-100", "translate-y-0", "scale-100")
    })
  }

  close() {
    if (this.backdropTarget.classList.contains("hidden")) return

    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")
    this.panelTarget.classList.remove("opacity-100", "translate-y-0", "scale-100")
    this.panelTarget.classList.add("opacity-0", "translate-y-4", "scale-95")
    document.removeEventListener("keydown", this.keydownHandler)

    setTimeout(() => {
      this.backdropTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
    }, 180)
  }

  closeFromBackdrop(event) {
    if (event.target === this.backdropTarget) this.close()
  }

  chooseUpload() {
    this.fileInputTarget.click()
  }

  uploadChanged() {
    const file = this.fileInputTarget.files?.[0]
    if (file) this.showPreview(file)
  }

  removeScreenshot() {
    this.fileInputTarget.value = ""
    this.previewTarget.classList.remove("flex")
    this.previewTarget.classList.add("hidden")
  }

  showPreview(file) {
    this.previewFilenameTarget.textContent = file.name
    this.previewTarget.classList.remove("hidden")
    this.previewTarget.classList.add("flex")
  }
}
