class CampTeamLinksController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    link = @camp_team.camp_team_links.new(camp_team_link_params.merge(position: next_position))

    if link.save
      ::Notifications::Triggers.team_link_added!(camp_team: @camp_team, link: link, actor: current_user)
      redirect_to team_page_path(@camp, @camp_team, focus_link: "1"), notice: "Link wurde gespeichert."
    else
      redirect_to team_page_path(@camp, @camp_team), alert: link.errors.full_messages.to_sentence
    end
  end

  def update
    link = @camp_team.camp_team_links.find(params[:id])

    if link.update(camp_team_link_params)
      redirect_to team_page_path(@camp, @camp_team), notice: "Link wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team), alert: link.errors.full_messages.to_sentence
    end
  end

  def destroy
    link = @camp_team.camp_team_links.find(params[:id])
    link.destroy

    redirect_to team_page_path(@camp, @camp_team), notice: "Link wurde entfernt."
  end

  def reorder
    reorder_links(@camp_team.camp_team_links)
  end

  private

  def camp_team_link_params
    params.require(:camp_team_link).permit(:title, :url)
  end

  def next_position
    (@camp_team.camp_team_links.maximum(:position) || -1) + 1
  end

  def reorder_links(links)
    ids = Array(params[:ids]).map(&:to_i)
    records = links.where(id: ids)

    return head :unprocessable_entity unless ids.present? && ids.uniq.length == ids.length && records.count == ids.length

    ActiveRecord::Base.transaction do
      ids.each_with_index { |id, position| records.find(id).update!(position: position) }
    end

    head :no_content
  end
end
