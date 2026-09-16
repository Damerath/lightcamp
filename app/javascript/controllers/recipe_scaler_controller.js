import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["servings", "amount", "token"]
  static values = { baseServings: Number }

  scale() {
    const servings = Number(this.servingsTarget.value)
    if (!Number.isFinite(servings) || servings <= 0) return
    this.amountTargets.forEach((element) => { element.textContent = this.format(Number(element.dataset.amount) * servings / this.baseServingsValue) })
    this.tokenTargets.forEach((element) => {
      const amount = this.format(Number(element.dataset.amount) * servings / this.baseServingsValue)
      element.textContent = element.dataset.kind === "amount" ? amount : `${amount} ${element.dataset.unit} ${element.dataset.name}`
    })
  }

  format(value) { return new Intl.NumberFormat("de-DE", { maximumFractionDigits: 3 }).format(value) }
}
