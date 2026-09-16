class NotificationDigestMailer < ApplicationMailer
  helper_method :notification_link

  def digest(user:, deliveries:)
    @user = user
    @deliveries = deliveries

    mail(to: user.email, subject: "Neuigkeiten aus Lightcamp HQ")
  end

  private

  def notification_link(delivery)
    return if delivery.link_url.blank?

    URI.join(default_url_options.fetch(:protocol, "https") + "://" + default_url_options.fetch(:host), delivery.link_url).to_s
  end
end
