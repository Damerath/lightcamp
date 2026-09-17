class AdminTeamTemplatesController < ApplicationController
  before_action :require_management

  def index
    @team_templates = TeamTemplate.order(:name)
    @active_year = Year.find_by(registration_open: true)
  end

  def show
    @team_template = TeamTemplate.find(params[:id])
    @active_year = Year.find_by(registration_open: true)
    @management_users = User.where(role: %w[admin leader]).order(:first_name, :last_name, :email)
    @section = params[:section].presence_in(%w[description links downloads]) || "description"
    @team_template_links = @team_template.team_template_links.ordered
    @team_template_download_items = @team_template.download_items.team_template_default.includes(:uploader, file_attachment: :blob).ordered
  end

  def update
    team_template = TeamTemplate.find(params[:id])
    old_description = team_template.description
    old_responsible_description = team_template.responsible_description

    if team_template.update(team_template_params)
      if team_template.saved_change_to_description? || team_template.saved_change_to_responsible_description?
        team_template.apply_default_change!(
          scope: propagation_scope,
          old_description: old_description,
          old_responsible_description: old_responsible_description,
          active_year: Year.find_by(registration_open: true)
        )
      end
      redirect_to team_template_update_path(team_template), notice: "Default wurde gespeichert."
    else
      redirect_to team_template_update_path(team_template), alert: team_template.errors.full_messages.to_sentence
    end
  end

  private

  def team_template_params
    params.require(:team_template).permit(:description, :responsible_description, :responsible_user_id)
  end

  def propagation_scope
    params[:propagate_scope].presence_in(%w[all future_years]) || "future_years"
  end

  def team_template_update_path(team_template)
    admin_team_template_path(team_template, section: params[:section].presence_in(%w[description links downloads]))
  end

  def require_management
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.management?
  end
end
