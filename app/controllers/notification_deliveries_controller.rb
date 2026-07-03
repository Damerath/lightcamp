class NotificationDeliveriesController < ApplicationController
  before_action :set_notification_delivery

  def visit
    @notification_delivery.mark_read!

    redirect_to safe_link_url(@notification_delivery.link_url)
  end

  def dismiss
    @notification_delivery.dismiss!

    redirect_back fallback_location: root_path
  end

  private

  def set_notification_delivery
    @notification_delivery = current_user.notification_deliveries.find(params[:id])
  end

  def safe_link_url(link_url)
    return root_path if link_url.blank?
    return link_url if link_url.start_with?("/") && !link_url.start_with?("//")

    root_path
  end
end
