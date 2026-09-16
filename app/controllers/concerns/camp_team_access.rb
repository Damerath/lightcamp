module CampTeamAccess
  extend ActiveSupport::Concern

  private

  # Schreibaktionen erhalten Camp- und Team-ID getrennt aus der URL.
  # Das Workspace-Team bündelt dabei Daten und Rechte zusammengehöriger Subteams.

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def require_team_access
    # Leitung darf jedes Team verwalten. Andere Nutzer müssen diesem Team zugeteilt sein.
    return if current_user&.management?
    return if current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diese Teamseite."
  end

  def require_freizeitleiter_access
    # Der Zimmerplan enthält campweite Personendaten. Zugriff haben daher nur
    # Leitung oder ein zugeteiltes Mitglied des Freizeitleiter-Teams.
    return if current_user&.management?
    return if @camp_team.name == "Freizeitleiter" && current_user.camp_applications.exists?(assigned_camp_team_id: @camp_team.workspace_team_ids)

    redirect_to camps_path, alert: "Kein Zugriff auf diesen Bereich."
  end
end
