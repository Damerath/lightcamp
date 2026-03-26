import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "content"]
  static values = { teamOptions: String }

  open(event) {
    const el = event.currentTarget
    const availableCamps = this.parseAvailableCamps(el.dataset.availableCamps)
    const assignmentOptions = availableCamps.map((camp) => {
      const selected = String(camp.id) === el.dataset.assignedCampId ? "selected" : ""
      return `<option value="${camp.id}" ${selected}>${this.escapeHtml(camp.name)}</option>`
    }).join("")
    const teamOptions = this.parseTeamOptions().map((team) => {
      const selected = team === el.dataset.assignedTeam ? "selected" : ""
      return `<option value="${this.escapeHtml(team)}" ${selected}>${this.escapeHtml(team)}</option>`
    }).join("")
    const currentAssignment = el.dataset.assignedCampName
      ? `Aktuell bestaetigt fuer: <strong>${this.escapeHtml(el.dataset.assignedCampName)}</strong>`
      : "Noch keinem Camp fest zugeteilt."
    const currentTeamAssignment = el.dataset.assignedTeam
      ? `Festes Team: <strong>${this.escapeHtml(el.dataset.assignedTeam)}</strong>`
      : "Noch kein Team fest zugeteilt."

    this.overlayTarget.classList.remove("hidden")

    this.contentTarget.innerHTML = `
      <div class="space-y-4">
        <div>
          <h4 class="text-lg font-semibold">${el.dataset.name}</h4>
          <p class="text-sm text-slate-500">${el.dataset.email}</p>
        </div>
        <div>
          <div><strong>Geburtsdatum:</strong> ${el.dataset.birthdate}</div>
          <div><strong>Telefon:</strong> ${el.dataset.phone}</div>
        </div>

        <div class="grid grid-cols-3 gap-4 text-sm">
          <div><strong>Camps:</strong> ${el.dataset.camps || "-"}</div>
          <div>
            <div><strong>Team:</strong> ${el.dataset.team || "-"}</div>
            <div><strong>Verantwortung:</strong> ${el.dataset.responsible}</div>
          </div>
          <div>
            <p class="font-medium">Bemerkung:</p>
            <p>${el.dataset.comment || "-"}</p>
          </div>
        </div>

        <div class="grid grid-cols-3 gap-4 text-sm">
          <div>
            <p class="font-medium">Motivation:</p>
            <p>${el.dataset.motivation || "-"}</p>
          </div>
          <div>
            <p class="font-medium">Gesundheitliche Einschränkungen:</p>
            <p>${el.dataset.health} ${el.dataset.healthDetails ? `- ${el.dataset.healthDetails}` : ""}</p>
          </div>
        </div>

        <form action="${el.dataset.assignmentPath}" accept-charset="UTF-8" method="post" class="space-y-3 rounded-xl border border-slate-200 p-4 dark:border-slate-700">
          <input type="hidden" name="_method" value="patch">
          <input type="hidden" name="authenticity_token" value="${this.csrfToken()}">

          <div>
            <p class="font-medium">Zuteilung</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">${currentAssignment}</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">${currentTeamAssignment}</p>
          </div>

          <div class="grid gap-3 sm:grid-cols-2">
            <div>
              <label class="mb-1 block text-sm font-medium" for="assigned-camp-select">Camp bestaetigen</label>
              <select id="assigned-camp-select" name="camp_application[assigned_camp_id]" class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 dark:border-slate-600 dark:bg-slate-900 dark:text-slate-100">
                <option value="">Noch nicht zuteilen</option>
                ${assignmentOptions}
              </select>
            </div>

            <div>
              <label class="mb-1 block text-sm font-medium" for="assigned-team-select">Team zuteilen</label>
              <select id="assigned-team-select" name="camp_application[assigned_team]" class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 dark:border-slate-600 dark:bg-slate-900 dark:text-slate-100">
                <option value="">Noch kein Team</option>
                ${teamOptions}
              </select>
            </div>
          </div>

          <button type="submit" class="rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white hover:bg-red-700">
            Speichern
          </button>
        </form>
      </div>
    `
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }

  parseAvailableCamps(campsJson) {
    try {
      return JSON.parse(campsJson || "[]")
    } catch (_error) {
      return []
    }
  }

  parseTeamOptions() {
    try {
      return JSON.parse(this.teamOptionsValue || "[]")
    } catch (_error) {
      return []
    }
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || ""
  }

  escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;")
  }
}
