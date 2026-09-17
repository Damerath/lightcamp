class AddLastReactivatedOnToLeadershipAnnualTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :leadership_annual_tasks, :last_reactivated_on, :date
  end
end
