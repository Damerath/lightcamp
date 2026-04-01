class AdminCampTeamTodosController < ApplicationController
  before_action :require_admin
  before_action :set_camp
  before_action :set_camp_team

  def create
    todo = @camp_team.camp_team_todos.new(camp_team_todo_params.merge(position: next_position))

    if todo.save
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde gespeichert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "todos"), alert: todo.errors.full_messages.to_sentence
    end
  end

  def update
    todo = @camp_team.camp_team_todos.find(params[:id])

    if todo.update(camp_team_todo_params)
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde aktualisiert."
    else
      redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "todos"), alert: todo.errors.full_messages.to_sentence
    end
  end

  def destroy
    todo = @camp_team.camp_team_todos.find(params[:id])
    todo.destroy

    redirect_to admin_camp_team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde entfernt."
  end

  private

  def set_camp
    @camp = Camp.find(params[:camp_id])
  end

  def set_camp_team
    @camp_team = @camp.camp_teams.find(params[:team_id]).workspace_team
    @camp = @camp_team.camp
  end

  def camp_team_todo_params
    params.require(:camp_team_todo).permit(:title, :completed)
  end

  def next_position
    (@camp_team.camp_team_todos.maximum(:position) || -1) + 1
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
