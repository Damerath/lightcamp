import { Controller } from "@hotwired/stimulus"
import { Datepicker } from "flowbite-datepicker"

export default class extends Controller {
  static targets = ["input", "value"]

  connect() {
    this.picker = new Datepicker(this.inputTarget, {
      autohide: true,
      todayBtn: true,
      clearBtn: true,
      todayHighlight: true,
      format: "dd.mm.yyyy"
    })

    this.handleChange = this.handleChange.bind(this)
    this.inputTarget.addEventListener("changeDate", this.handleChange)

    if (this.valueTarget.value) {
      this.picker.setDate(this.valueTarget.value)
      this.inputTarget.value = this.formatForDisplay(this.valueTarget.value)
    }
  }

  open() {
    this.picker?.show()
  }

  disconnect() {
    this.inputTarget.removeEventListener("changeDate", this.handleChange)
    this.picker?.destroy()
  }

  handleChange() {
    const selected = this.picker?.getDate("yyyy-mm-dd")
    this.valueTarget.value = selected || ""
  }

  formatForDisplay(isoDate) {
    const [year, month, day] = String(isoDate).split("-")
    if (!year || !month || !day) return ""

    return `${day}.${month}.${year}`
  }
}
