class AddDigestLookupIndexToNotificationDeliveries < ActiveRecord::Migration[7.1]
  def change
    add_index :notification_deliveries, [:channel_kind, :status, :user_id, :created_at], name: "idx_notification_deliveries_for_digests"
  end
end
