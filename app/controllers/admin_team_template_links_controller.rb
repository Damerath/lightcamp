class AdminTeamTemplateLinksController < ApplicationController
  before_action :require_admin
  before_action :set_team_template

  def create
    link = @team_template.team_template_links.new(team_template_link_params.merge(position: next_position))

    if link.save
      redirect_to admin_team_template_path(@team_template), notice: "Default-Link wurde gespeichert."
    else
      redirect_to admin_team_template_path(@team_template), alert: link.errors.full_messages.to_sentence
    end
  end

  def update
    link = @team_template.team_template_links.find(params[:id])

    if link.update(team_template_link_params)
      redirect_to admin_team_template_path(@team_template), notice: "Default-Link wurde aktualisiert."
    else
      redirect_to admin_team_template_path(@team_template), alert: link.errors.full_messages.to_sentence
    end
  end

  def destroy
    link = @team_template.team_template_links.find(params[:id])
    link.destroy

    redirect_to admin_team_template_path(@team_template), notice: "Default-Link wurde entfernt."
  end

  private

  def set_team_template
    @team_template = TeamTemplate.find(params[:team_template_id])
  end

  def team_template_link_params
    params.require(:team_template_link).permit(:title, :url)
  end

  def next_position
    (@team_template.team_template_links.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
