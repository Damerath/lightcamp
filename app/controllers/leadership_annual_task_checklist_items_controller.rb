class LeadershipAnnualTaskChecklistItemsController < ApplicationController
  before_action :require_management
  before_action :set_task
  before_action :set_item, only: %i[update destroy]

  def create
    item = @task.checklist_items.new(item_params.merge(position: next_position))

    if item.save
      redirect_to leadership_annual_task_path(@task, focus_item: "1"), notice: "Checklistenpunkt wurde hinzugefügt."
    else
      redirect_to leadership_annual_task_path(@task), alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    completed = ActiveModel::Type::Boolean.new.cast(params.dig(:leadership_annual_task_checklist_item, :completed))

    if @item.update(completed: completed, completed_at: completed ? Time.current : nil)
      redirect_to leadership_annual_task_path(@task), notice: completed ? "Checklistenpunkt wurde erledigt." : "Checklistenpunkt ist wieder offen."
    else
      redirect_to leadership_annual_task_path(@task), alert: @item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @item.destroy
    redirect_to leadership_annual_task_path(@task), notice: "Checklistenpunkt wurde gelöscht."
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i)
    unfinished_items = @task.checklist_items.unfinished
    items = unfinished_items.where(id: ids)

    return head :unprocessable_entity unless ids.present? && ids.uniq.length == ids.length && items.count == unfinished_items.count

    ActiveRecord::Base.transaction do
      ids.each_with_index { |id, position| items.find(id).update!(position: position) }
    end

    head :no_content
  end

  private

  def set_task
    @task = LeadershipAnnualTask.find(params[:leadership_annual_task_id])
  end

  def set_item
    @item = @task.checklist_items.find(params[:id])
  end

  def item_params
    params.require(:leadership_annual_task_checklist_item).permit(:text)
  end

  def next_position
    (@task.checklist_items.unfinished.maximum(:position) || -1) + 1
  end
end
