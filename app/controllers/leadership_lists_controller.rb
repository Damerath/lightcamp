class LeadershipListsController < ApplicationController
  before_action :require_management
  before_action :set_leadership_list, only: %i[show update destroy]

  def index
    @leadership_lists = LeadershipList.ordered
  end

  def show
    @unfinished_items = @leadership_list.items.unfinished
    @completed_items = @leadership_list.items.completed_recently
  end

  def create
    leadership_list = LeadershipList.new(leadership_list_params)

    if leadership_list.save
      redirect_to leadership_list_path(leadership_list), notice: "Liste wurde angelegt."
    else
      redirect_to leadership_lists_path(modal: "new"), alert: leadership_list.errors.full_messages.to_sentence
    end
  end

  def update
    if @leadership_list.update(leadership_list_params)
      redirect_to leadership_list_path(@leadership_list), notice: "Liste wurde aktualisiert."
    else
      redirect_to leadership_list_path(@leadership_list), alert: @leadership_list.errors.full_messages.to_sentence
    end
  end

  def destroy
    @leadership_list.destroy
    redirect_to leadership_lists_path, notice: "Liste wurde gelöscht."
  end

  private

  def set_leadership_list
    @leadership_list = LeadershipList.find(params[:id])
  end

  def leadership_list_params
    params.require(:leadership_list).permit(:title, :description)
  end
end
