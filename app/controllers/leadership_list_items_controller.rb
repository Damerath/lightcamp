class LeadershipListItemsController < ApplicationController
  before_action :require_management
  before_action :set_leadership_list
  before_action :set_item, only: %i[update destroy]

  def create
    item = @leadership_list.items.new(item_params.merge(position: next_position))

    if item.save
      redirect_to leadership_list_path(@leadership_list, focus_item: "1"), notice: "Punkt wurde hinzugefügt."
    else
      redirect_to leadership_list_path(@leadership_list), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    completed = ActiveModel::Type::Boolean.new.cast(params.dig(:leadership_list_item, :completed))

    if @item.update(completed: completed, completed_at: completed ? Time.current : nil)
      redirect_to leadership_list_path(@leadership_list), notice: completed ? "Punkt wurde erledigt." : "Punkt ist wieder offen."
    else
      redirect_to leadership_list_path(@leadership_list), alert: @item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @item.destroy
    redirect_to leadership_list_path(@leadership_list), notice: "Punkt wurde gelöscht."
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i)
    unfinished_items = @leadership_list.items.unfinished
    items = unfinished_items.where(id: ids)

    return head :unprocessable_entity unless ids.present? && ids.uniq.length == ids.length && items.count == unfinished_items.count

    ActiveRecord::Base.transaction do
      ids.each_with_index { |id, position| items.find(id).update!(position: position) }
    end

    head :no_content
  end

  private

  def set_leadership_list
    @leadership_list = LeadershipList.find(params[:leadership_list_id])
  end

  def set_item
    @item = @leadership_list.items.find(params[:id])
  end

  def item_params
    params.require(:leadership_list_item).permit(:text)
  end

  def next_position
    (@leadership_list.items.unfinished.maximum(:position) || -1) + 1
  end
end
