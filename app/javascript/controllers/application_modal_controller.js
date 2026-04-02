import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "content"]

  open(event) {
    const el = event.currentTarget
    this.campTeams = this.parseCampTeams(el.dataset.campTeams)
    this.selectedCampId = el.dataset.assignedCampId || this.campTeams[0]?.id?.toString() || ""
    this.selectedCampTeamId = el.dataset.assignedCampTeamId || ""
    const currentAssignment = el.dataset.assignedCampName
      ? `Aktuell eingeplant für: <strong>${this.escapeHtml(el.dataset.assignedCampName)}</strong>`
      : "Noch keinem Camp fest zugeteilt."
    const currentTeamAssignment = el.dataset.assignedTeam
      ? `Team: <strong>${this.escapeHtml(el.dataset.assignedTeam)}</strong>`
      : "Noch kein Team fest zugeteilt."
    const currentResponsibleAssignment = el.dataset.assignedAsResponsible === "true"
      ? "Rolle: <strong>verantwortlich</strong>"
      : "Rolle: <strong>normales Teammitglied</strong>"

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

        <div class="grid grid-cols-3 gap-6">
          <div class="grid grid-rows-5 text-sm">
            <div><strong>Campdaten:</strong></div>
            <div>Camps: ${el.dataset.camps || "-"}</div>
            <div>Team: ${el.dataset.team || "-"}</div>
            <div>Verantwortung: ${el.dataset.responsible}</div>
            <div>Bemerkung: ${el.dataset.comment || "-"}</div>
          </div>

          <div class="grid grid-rows-5 text-sm">
            <div><strong>Fähigkeiten:</strong></div>
            <div>Ersthelfer:</strong> ${el.dataset.firstAider || "Nein"}</div>
            <div>Tontechnik: ${el.dataset.soundTech || "Nein"}</div>
            <div>Instrumente: ${el.dataset.instruments || "-"}</div>
            <div>Sonstige: ${el.dataset.otherSkills || "-"}</div>
          </div>

          <div class="grid grid-rows-5 text-sm">
            <div><strong>Motivation:</strong></div>
            <div>${el.dataset.motivation || "-"}</div>
            <br>
            <div><strong>Gesundheitliches:</strong></div>
            <div>${el.dataset.health} ${el.dataset.healthDetails ? `- ${el.dataset.healthDetails}` : ""}</div>
          </div>
        </div>
        <form action="${el.dataset.assignmentPath}" accept-charset="UTF-8" method="post" class="space-y-3 rounded-xl border border-slate-200 p-4 dark:border-slate-700" data-action="submit->application-modal#syncAssignment">
          <input type="hidden" name="_method" value="patch">
          <input type="hidden" name="authenticity_token" value="${this.csrfToken()}">
          <input type="hidden" name="return_to" value="${this.escapeHtml(window.location.pathname + window.location.search)}">
          <input type="hidden" name="camp_application[assigned_camp_team_id]" value="${this.escapeHtml(this.selectedCampTeamId)}" data-role="assigned-camp-team-hidden">

          <div>
            <p class="font-medium">Zuteilung</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">${currentAssignment}</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">${currentTeamAssignment}</p>
            <p class="text-sm text-slate-500 dark:text-slate-400">${currentResponsibleAssignment}</p>
          </div>

          <div class="grid gap-3 sm:grid-cols-2">
            <div>
              <label class="mb-1 block text-sm font-medium" for="assigned-camp-select">Camp bestaetigen</label>
              <select id="assigned-camp-select" data-role="assigned-camp-select" class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 dark:border-slate-600 dark:bg-slate-900 dark:text-slate-100" data-action="change->application-modal#campChanged">
                <option value="">Noch nicht zuteilen</option>
                ${this.renderCampOptions()}
              </select>
            </div>

            <div>
              <label class="mb-1 block text-sm font-medium" for="assigned-camp-team-select">Team zuteilen</label>
              <select id="assigned-camp-team-select" data-role="assigned-camp-team-select" class="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm text-slate-900 dark:border-slate-600 dark:bg-slate-900 dark:text-slate-100" data-action="change->application-modal#teamChanged">
                <option value="">Noch kein Team</option>
              </select>
            </div>
          </div>

          <label class="flex cursor-pointer items-start gap-3 rounded-lg border border-slate-300 bg-white px-4 py-3 transition hover:border-blue-400 hover:bg-slate-50 dark:border-slate-600 dark:bg-slate-900 dark:hover:border-blue-500 dark:hover:bg-slate-800" data-role="assigned-responsible-card">
            <input type="checkbox" name="camp_application[assigned_as_responsible]" value="1" ${el.dataset.assignedAsResponsible === "true" ? "checked" : ""} class="mt-0.5 h-4 w-4 rounded border-slate-300 text-blue-500 focus:ring-blue-400 dark:border-slate-600 dark:bg-slate-900" data-role="assigned-responsible-checkbox">
            <div>
              <p class="text-sm font-medium text-slate-900 dark:text-slate-100">Als verantwortliche Person zuteilen</p>
              <p class="text-sm text-slate-500 dark:text-slate-400">Nur sinnvoll, wenn das gewaehlte Team Verantwortlichen-Plaetze hat.</p>
            </div>
          </label>
          <p class="text-xs text-slate-500 dark:text-slate-400" data-role="responsible-hint"></p>

          <button type="submit" class="rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white hover:bg-red-700">
            Speichern
          </button>
        </form>
      </div>
    `

    this.refreshTeamOptions()
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }

  campChanged(event) {
    this.selectedCampId = event.currentTarget.value
    this.selectedCampTeamId = ""
    this.refreshTeamOptions()
  }

  teamChanged(event) {
    this.selectedCampTeamId = event.currentTarget.value
    this.syncHiddenAssignmentField()
    this.refreshResponsibleHint()
  }

  syncAssignment() {
    this.syncHiddenAssignmentField()
  }

  parseCampTeams(campTeamsJson) {
    try {
      return JSON.parse(campTeamsJson || "[]")
    } catch (_error) {
      return []
    }
  }

  renderCampOptions() {
    return this.campTeams.map((camp) => {
      const selected = String(camp.id) === String(this.selectedCampId) ? "selected" : ""
      return `<option value="${camp.id}" ${selected}>${this.escapeHtml(camp.name)}</option>`
    }).join("")
  }

  refreshTeamOptions() {
    const teamSelect = this.contentTarget.querySelector('[data-role="assigned-camp-team-select"]')
    if (!teamSelect) return

    const selectedCamp = this.campTeams.find((camp) => String(camp.id) === String(this.selectedCampId))
    const teamOptions = selectedCamp ? selectedCamp.teams : []

    teamSelect.innerHTML = `
      <option value="">Noch kein Team</option>
      ${teamOptions.map((team) => {
        const selected = String(team.id) === String(this.selectedCampTeamId) ? "selected" : ""
        return `<option value="${team.id}" ${selected}>${this.escapeHtml(team.name)}</option>`
      }).join("")}
    `

    if (!teamOptions.some((team) => String(team.id) === String(this.selectedCampTeamId))) {
      this.selectedCampTeamId = ""
    }

    teamSelect.value = this.selectedCampTeamId
    this.syncHiddenAssignmentField()

    this.refreshResponsibleHint()
  }

  refreshResponsibleHint() {
    const hint = this.contentTarget.querySelector('[data-role="responsible-hint"]')
    const checkbox = this.contentTarget.querySelector('[data-role="assigned-responsible-checkbox"]')
    const card = this.contentTarget.querySelector('[data-role="assigned-responsible-card"]')
    if (!hint || !checkbox || !card) return

    const selectedCamp = this.campTeams.find((camp) => String(camp.id) === String(this.selectedCampId))
    const selectedTeam = selectedCamp?.teams.find((team) => String(team.id) === String(this.selectedCampTeamId))

    if (!selectedTeam) {
      hint.textContent = "Waehle zuerst ein Team aus."
      checkbox.disabled = true
      checkbox.checked = false
      this.updateResponsibleCardState(card, true)
      return
    }

    if (selectedTeam.responsible_slots > 0) {
      hint.textContent = `Dieses Team hat ${selectedTeam.responsible_slots} Verantwortlichen-Platz${selectedTeam.responsible_slots === 1 ? "" : "e"}.`
      checkbox.disabled = false
      this.updateResponsibleCardState(card, false)
      return
    }

    hint.textContent = "Dieses Team hat keinen Verantwortlichen-Platz."
    checkbox.disabled = true
    checkbox.checked = false
    this.updateResponsibleCardState(card, true)
  }

  syncHiddenAssignmentField() {
    const hiddenField = this.contentTarget.querySelector('[data-role="assigned-camp-team-hidden"]')
    if (!hiddenField) return

    hiddenField.value = this.selectedCampTeamId || ""
  }

  updateResponsibleCardState(card, disabled) {
    const disabledClasses = ["cursor-not-allowed", "opacity-60", "hover:border-slate-300", "hover:bg-white", "dark:hover:border-slate-600", "dark:hover:bg-slate-900"]
    const enabledClasses = ["cursor-pointer", "hover:border-blue-400", "hover:bg-slate-50", "dark:hover:border-blue-500", "dark:hover:bg-slate-800"]

    card.classList.remove(...disabledClasses, ...enabledClasses)

    if (disabled) {
      card.classList.add(...disabledClasses)
    } else {
      card.classList.add(...enabledClasses)
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
