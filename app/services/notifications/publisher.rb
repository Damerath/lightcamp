module Notifications
  class Publisher
    def self.publish!(key:, deliveries:, actor: nil, metadata: {})
      normalized_deliveries = Array(deliveries).filter_map do |entry|
        user = entry[:user]
        next if user.blank?

        {
          user: user,
          channel_kind: entry[:channel_kind] || :in_app,
          title: entry[:title].to_s.strip,
          body: entry[:body].to_s.strip,
          link_url: entry[:link_url].presence
        }
      end

      normalized_deliveries.select! { |entry| entry[:title].present? && entry[:body].present? }
      normalized_deliveries.uniq! { |entry| [entry[:user].id, entry[:channel_kind].to_s, entry[:title], entry[:body], entry[:link_url]] }

      return if normalized_deliveries.empty?

      NotificationEvent.transaction do
        event = NotificationEvent.create!(key: key, actor: actor, metadata: metadata)

        normalized_deliveries.each do |delivery|
          event.notification_deliveries.create!(
            user: delivery[:user],
            channel_kind: delivery[:channel_kind],
            title: delivery[:title],
            body: delivery[:body],
            link_url: delivery[:link_url],
            status: :delivered,
            delivered_at: Time.current
          )
        end

        event
      end
    end
  end
end
