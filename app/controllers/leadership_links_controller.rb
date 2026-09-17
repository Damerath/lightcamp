class LeadershipLinksController < ApplicationController
  before_action :require_management

  def index
    @leadership_links = LeadershipLink.ordered
  end

  def create
    link = LeadershipLink.new(leadership_link_params.merge(position: next_position))

    if link.save
      redirect_to leadership_links_path(focus_link: "1"), notice: "Leitungs-Link wurde gespeichert."
    else
      redirect_to leadership_links_path, alert: link.errors.full_messages.to_sentence
    end
  end

  def destroy
    LeadershipLink.find(params[:id]).destroy
    redirect_to leadership_links_path, notice: "Leitungs-Link wurde entfernt."
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i)
    links = LeadershipLink.where(id: ids)

    return head :unprocessable_entity unless ids.present? && ids.uniq.length == ids.length && links.count == ids.length

    ActiveRecord::Base.transaction do
      ids.each_with_index { |id, position| links.find(id).update!(position: position) }
    end

    head :no_content
  end

  private

  def leadership_link_params
    params.require(:leadership_link).permit(:title, :url)
  end

  def next_position
    (LeadershipLink.maximum(:position) || -1) + 1
  end
end
