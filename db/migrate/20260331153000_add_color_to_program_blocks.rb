class AddColorToProgramBlocks < ActiveRecord::Migration[7.1]
  def change
    add_column :camp_program_blocks, :color, :string, null: false, default: "blue"
    add_column :camp_program_week_blocks, :color, :string, null: false, default: "blue"
  end
end
