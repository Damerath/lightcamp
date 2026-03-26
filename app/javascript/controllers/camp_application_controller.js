import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["yearSelect", "campGroup"]

  connect() {
    this.filterCamps()
  }

  filterCamps() {
    const selectedYearId = this.yearSelectTarget.value

    this.campGroupTargets.forEach((group) => {
      if (group.dataset.yearId === selectedYearId) {
        group.classList.remove("hidden")
      } else {
        group.classList.add("hidden")
      }
    })
  }
}