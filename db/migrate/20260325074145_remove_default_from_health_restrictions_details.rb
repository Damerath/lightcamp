class RemoveDefaultFromHealthRestrictionsDetails < ActiveRecord::Migration[7.1]
  def change
    change_column_default :camp_applications, :health_restrictions_details, from: "f", to: nil
  end
end
