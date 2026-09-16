class CampKitchenRecipeAssignmentsController < ApplicationController
  include CampTeamAccess

  before_action :set_camp
  before_action :set_camp_team
  before_action :require_kitchen_recipe_manager

  def create
    kitchen_day_plan = @camp_team.camp_kitchen_day_plans.find(params[:kitchen_day_plan_id])
    assignment = kitchen_day_plan.recipe_assignments.new(recipe_assignment_params)

    if assignment.save
      redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), notice: "Rezept wurde im Küchenplan verknüpft."
    else
      redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), alert: assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    assignment = @camp_team.camp_kitchen_day_plans.find(params[:kitchen_day_plan_id]).recipe_assignments.find(params[:id])
    assignment.destroy

    redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), notice: "Rezept wurde aus dem Küchenplan entfernt."
  end

  private

  def require_kitchen_recipe_manager
    return if @camp_team.kitchen_recipe_manager?(current_user)

    redirect_to team_page_path(@camp, @camp_team, section: "kitchen_plan"), alert: "Nur Küchenverantwortliche dürfen Rezepte im Küchenplan verknüpfen."
  end

  def recipe_assignment_params
    meal_slot = params[:meal_slot]
    recipe_id = params.dig(:kitchen_recipe_assignment, :recipe_ids, meal_slot)

    { meal_slot: meal_slot, kitchen_recipe_id: recipe_id }
  end
end
