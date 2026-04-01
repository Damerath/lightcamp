class AddDateRangeToCamps < ActiveRecord::Migration[7.1]
  def change
    add_column :camps, :start_on, :date
    add_column :camps, :end_on, :date
  end
end
