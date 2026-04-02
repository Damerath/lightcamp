import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "title", "message", "confirmButton", "cancelButton"]

  connect() {
    this.turbo = window.Turbo
    if (!this.turbo?.config?.forms) return

    this.turbo.config.forms.confirm = (message, formElement, submitter) =>
      this.confirm(message, formElement, submitter)
  }

  disconnect() {
    if (this.turbo?.config?.forms) {
      this.turbo.config.forms.confirm = undefined
    }
    this.teardownPending()
  }

  confirm(message, formElement, submitter) {
    this.teardownPending()

    const destructive = this.isDestructive(formElement, submitter, message)
    this.messageTarget.textContent = message
    this.titleTarget.textContent = destructive ? "Bist du sicher?" : "Bitte bestätigen"
    this.confirmButtonTarget.textContent = destructive ? "Ja, fortfahren" : "Bestätigen"
    this.confirmButtonTarget.className = this.confirmButtonClass(destructive)

    this.element.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")

    return new Promise((resolve) => {
      this.pendingResolve = resolve

      this.confirmHandler = () => this.finish(true)
      this.cancelHandler = () => this.finish(false)
      this.keydownHandler = (event) => {
        if (event.key === "Escape") this.finish(false)
      }

      this.confirmButtonTarget.addEventListener("click", this.confirmHandler)
      this.cancelButtonTarget.addEventListener("click", this.cancelHandler)
      document.addEventListener("keydown", this.keydownHandler)

      requestAnimationFrame(() => {
        this.backdropTarget.classList.remove("opacity-0")
        this.backdropTarget.classList.add("opacity-100")
        this.panelTarget.classList.remove("opacity-0", "translate-y-4", "scale-95")
        this.panelTarget.classList.add("opacity-100", "translate-y-0", "scale-100")
        this.cancelButtonTarget.focus()
      })
    })
  }

  closeFromBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.finish(false)
    }
  }

  finish(result) {
    if (!this.pendingResolve) return

    const resolve = this.pendingResolve
    this.pendingResolve = null

    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")
    this.panelTarget.classList.remove("opacity-100", "translate-y-0", "scale-100")
    this.panelTarget.classList.add("opacity-0", "translate-y-4", "scale-95")

    this.teardownPending()

    setTimeout(() => {
      this.element.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
      resolve(result)
    }, 180)
  }

  teardownPending() {
    if (this.confirmHandler) {
      this.confirmButtonTarget.removeEventListener("click", this.confirmHandler)
      this.confirmHandler = null
    }

    if (this.cancelHandler) {
      this.cancelButtonTarget.removeEventListener("click", this.cancelHandler)
      this.cancelHandler = null
    }

    if (this.keydownHandler) {
      document.removeEventListener("keydown", this.keydownHandler)
      this.keydownHandler = null
    }
  }

  isDestructive(formElement, submitter, message) {
    const method =
      submitter?.dataset?.turboMethod ||
      formElement?.getAttribute("method") ||
      formElement?.dataset?.turboMethod ||
      ""

    if (String(method).toLowerCase() === "delete") return true

    const text = `${message} ${submitter?.textContent || ""}`.toLowerCase()
    return ["löschen", "löschen", "entfernen", "zurücksetzen", "zurücksetzen", "wiederherstellen"].some((term) =>
      text.includes(term)
    )
  }

  confirmButtonClass(destructive) {
    if (destructive) {
      return "inline-flex rounded-lg bg-red-600 px-4 py-2.5 text-sm font-medium text-white transition hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-400"
    }

    return "inline-flex rounded-lg bg-slate-900 px-4 py-2.5 text-sm font-medium text-white transition hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-400 dark:bg-slate-100 dark:text-slate-900 dark:hover:bg-slate-200"
  }
}
