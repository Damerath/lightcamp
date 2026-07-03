class CreateNotificationEventsAndDeliveries < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_events do |t|
      t.string :key, null: false
      t.references :actor, foreign_key: { to_table: :users }
      t.jsonb :metadata, null: false, default: {}
      t.timestamps
    end

    create_table :notification_deliveries do |t|
      t.references :notification_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :channel_kind, null: false, default: 0
      t.integer :status, null: false, default: 2
      t.string :title, null: false
      t.text :body, null: false
      t.text :link_url
      t.datetime :read_at
      t.datetime :dismissed_at
      t.datetime :attempted_at
      t.datetime :delivered_at
      t.datetime :failed_at
      t.text :failure_reason
      t.timestamps
    end

    add_index :notification_events, :key
    add_index :notification_deliveries, [:user_id, :channel_kind, :dismissed_at], name: "idx_notification_deliveries_on_user_channel_dismissed"
    add_index :notification_deliveries, [:notification_event_id, :user_id, :channel_kind], unique: true, name: "idx_notification_deliveries_uniqueness"
  end
end
