class AddWeekPlanPublishedToCampTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_teams, :week_plan_published, :boolean, null: false, default: false
  end
end
