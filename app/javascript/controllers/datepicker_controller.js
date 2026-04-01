import { Controller } from "@hotwired/stimulus"
import { Datepicker } from "flowbite-datepicker"

Datepicker.locales.de = {
  days: ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
  daysShort: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
  daysMin: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
  months: ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"],
  monthsShort: ["Jan", "Feb", "Mrz", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"],
  today: "Heute",
  clear: "Leeren",
  titleFormat: "MM y"
}

export default class extends Controller {
  static targets = ["input", "value"]
  static values = { defaultToToday: Boolean }

  connect() {
    const storedIsoDate = this.valueTarget.value
    this.inputTarget.value = storedIsoDate ? this.formatForDisplay(storedIsoDate) : ""
    const storedDateObject = this.parseIsoDate(storedIsoDate)

    this.picker = new Datepicker(this.inputTarget, {
      autohide: true,
      todayBtn: true,
      clearBtn: true,
      todayHighlight: true,
      format: "dd.mm.yyyy",
      language: "de",
      defaultViewDate: storedDateObject || new Date()
    })

    if (storedDateObject) {
      this.picker.setDate(storedDateObject)
    }

    this.handleChange = this.handleChange.bind(this)
    this.inputTarget.addEventListener("changeDate", this.handleChange)
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
    this.inputTarget.value = selected ? this.formatForDisplay(selected) : ""
  }

  formatForDisplay(isoDate) {
    const [year, month, day] = String(isoDate).split("-")
    if (!year || !month || !day) return ""

    return `${day}.${month}.${year}`
  }

  todayIsoDate() {
    const today = new Date()
    const year = today.getFullYear()
    const month = String(today.getMonth() + 1).padStart(2, "0")
    const day = String(today.getDate()).padStart(2, "0")

    return `${year}-${month}-${day}`
  }

  parseIsoDate(isoDate) {
    const [year, month, day] = String(isoDate || "").split("-").map(Number)
    if (!year || !month || !day) return null

    return new Date(year, month - 1, day)
  }
}
