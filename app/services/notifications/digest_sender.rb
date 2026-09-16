module Notifications
  class DigestSender
    DELIVERY_DELAY = 2.hours

    class << self
      def run!(now: Time.current)
        NotificationDelivery.pending_email.reorder(nil).distinct.pluck(:user_id).each do |user_id|
          send_due_digest!(user_id, now: now)
        end
      end

      private

      def send_due_digest!(user_id, now:)
        user = User.find_by(id: user_id)
        return if user.blank?

        deliveries = claim_due_deliveries(user, now: now)
        return if deliveries.empty?

        NotificationDigestMailer.digest(user: user, deliveries: deliveries).deliver_now
        NotificationDelivery.where(id: deliveries).update_all(status: :delivered, delivered_at: now, updated_at: now)
      rescue StandardError => error
        NotificationDelivery.where(id: deliveries).update_all(
          status: :failed,
          failed_at: now,
          failure_reason: error.message.truncate(500),
          updated_at: now
        ) if deliveries.present?

        Rails.logger.error("Notification digest for user #{user_id} failed: #{error.class}: #{error.message}")
      end

      def claim_due_deliveries(user, now:)
        NotificationDelivery.transaction do
          deliveries = user.notification_deliveries.pending_email.lock.to_a
          return [] if deliveries.empty?
          return [] if deliveries.first.created_at > now - DELIVERY_DELAY

          deliveries.each { |delivery| delivery.update!(status: :attempted, attempted_at: now, failure_reason: nil) }
          deliveries
        end
      end
    end
  end
end
