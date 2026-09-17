class CreateLeadershipAnnualTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :leadership_annual_tasks do |t|
      t.string :title, null: false
      t.text :description
      t.text :comment, null: false, default: ""
      t.references :responsible_user, null: false, foreign_key: { to_table: :users }
      t.integer :due_month, null: false
      t.integer :due_day, null: false
      t.integer :reactivation_month, null: false
      t.integer :reactivation_day, null: false
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :leadership_annual_tasks, %i[active completed due_month due_day], name: "index_annual_tasks_for_overview"

    create_table :leadership_annual_task_checklist_items do |t|
      t.references :leadership_annual_task, null: false, foreign_key: true, index: { name: "index_annual_checklist_items_on_task" }
      t.string :text, null: false
      t.integer :position, null: false, default: 0
      t.boolean :completed, null: false, default: false
      t.datetime :completed_at
      t.timestamps
    end

    add_index :leadership_annual_task_checklist_items, %i[leadership_annual_task_id completed position], name: "index_annual_checklist_items_for_order"

    create_table :leadership_annual_task_reminders do |t|
      t.references :leadership_annual_task, null: false, foreign_key: true, index: { name: "index_annual_task_reminders_on_task" }
      t.integer :days_before, null: false
      t.timestamps
    end

    add_index :leadership_annual_task_reminders, %i[leadership_annual_task_id days_before], unique: true, name: "index_annual_task_reminders_uniqueness"

    create_table :leadership_annual_task_reminder_deliveries do |t|
      t.references :leadership_annual_task, null: false, foreign_key: true, index: { name: "index_annual_reminder_deliveries_on_task" }
      t.references :leadership_annual_task_reminder, null: false, foreign_key: true, index: { name: "index_annual_reminder_deliveries_on_reminder" }
      t.date :due_on, null: false
      t.datetime :in_app_notified_at
      t.datetime :emailed_at
      t.timestamps
    end

    add_index :leadership_annual_task_reminder_deliveries, %i[leadership_annual_task_reminder_id due_on], unique: true, name: "index_annual_reminder_deliveries_uniqueness"
  end
end
