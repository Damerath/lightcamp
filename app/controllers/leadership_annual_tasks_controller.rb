class LeadershipAnnualTasksController < ApplicationController
  before_action :require_management
  before_action :set_task, only: %i[show update destroy complete reactivate reminders destroy_reminder]

  def index
    tasks = LeadershipAnnualTask.active.includes(:responsible_user, :checklist_items)
    @open_tasks = tasks.open.to_a.sort_by { |task| task.next_due_on || Date.new(9999, 12, 31) }
    @completed_tasks = tasks.completed_recently
    @inactive_tasks = LeadershipAnnualTask.where(active: false).includes(:responsible_user).order(:title)
    @management_users = management_users
  end

  def show
    @unfinished_items = @task.checklist_items.unfinished
    @completed_items = @task.checklist_items.completed_recently
    @management_users = management_users
  end

  def create
    task = LeadershipAnnualTask.new(task_params)

    if task.save
      redirect_to leadership_annual_task_path(task), notice: "Jahresaufgabe wurde angelegt."
    else
      redirect_to leadership_annual_tasks_path(modal: "new"), alert: task.errors.full_messages.to_sentence
    end
  end

  def update
    if @task.update(task_params)
      redirect_to leadership_annual_task_path(@task), notice: "Jahresaufgabe wurde aktualisiert."
    else
      redirect_to leadership_annual_task_path(@task, modal: "edit"), alert: @task.errors.full_messages.to_sentence
    end
  end

  def destroy
    @task.destroy
    redirect_to leadership_annual_tasks_path, notice: "Jahresaufgabe wurde gelöscht."
  end

  def complete
    @task.complete!
    redirect_to leadership_annual_tasks_path, notice: "Jahresaufgabe wurde als erledigt markiert."
  end

  def reactivate
    @task.reactivate!(date: Date.current, update_reactivation_date: true)
    redirect_to leadership_annual_tasks_path, notice: "Jahresaufgabe wurde reaktiviert."
  end

  def reminders
    reminder = @task.reminders.new(days_before: params.dig(:leadership_annual_task_reminder, :days_before))

    if reminder.save
      redirect_to leadership_annual_task_path(@task, modal: "edit"), notice: "Erinnerung wurde hinzugefügt."
    else
      redirect_to leadership_annual_task_path(@task, modal: "edit"), alert: reminder.errors.full_messages.to_sentence
    end
  end

  def destroy_reminder
    @task.reminders.find(params[:reminder_id]).destroy
    redirect_to leadership_annual_task_path(@task, modal: "edit"), notice: "Erinnerung wurde entfernt."
  end

  private

  def set_task
    @task = LeadershipAnnualTask.find(params[:id])
  end

  def task_params
    params.require(:leadership_annual_task).permit(
      :title, :description, :comment, :responsible_user_id,
      :due_month, :due_day, :reactivation_month, :reactivation_day, :active
    )
  end

  def management_users
    User.where(role: %w[admin leader]).order(:first_name, :last_name, :email)
  end
end
