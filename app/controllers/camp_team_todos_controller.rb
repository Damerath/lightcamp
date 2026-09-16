class CampTeamTodosController < ApplicationController
  include CampTeamAccess
  before_action :set_camp
  before_action :set_camp_team
  before_action :require_team_access

  def create
    todo = @camp_team.camp_team_todos.new(camp_team_todo_params.merge(position: next_position))

    if todo.save
      ::Notifications::Triggers.team_todo_added!(camp_team: @camp_team, todo: todo, actor: current_user)
      redirect_to team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde gespeichert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "todos"), alert: todo.errors.full_messages.to_sentence
    end
  end

  def update
    todo = @camp_team.camp_team_todos.find(params[:id])

    if todo.update(camp_team_todo_params)
      redirect_to team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde aktualisiert."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "todos"), alert: todo.errors.full_messages.to_sentence
    end
  end

  def destroy
    todo = @camp_team.camp_team_todos.find(params[:id])
    todo.destroy

    redirect_to team_page_path(@camp, @camp_team, section: "todos"), notice: "ToDo wurde entfernt."
  end

  private

  def camp_team_todo_params
    params.require(:camp_team_todo).permit(:title, :completed)
  end

  def next_position
    (@camp_team.camp_team_todos.maximum(:position) || -1) + 1
  end
end
