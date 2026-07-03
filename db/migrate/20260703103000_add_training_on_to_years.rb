class AddTrainingOnToYears < ActiveRecord::Migration[7.1]
  def change
    add_column :years, :training_on, :date
  end
end
