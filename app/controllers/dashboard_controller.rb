class DashboardController < ApplicationController
  def index
    @active_year = Year.find_by(registration_open: true)

    @application_status =
      if @active_year.nil?
        nil
      elsif current_user.camp_applications.exists?(year: @active_year)
        :submitted
      else
        :not_applied
      end
  end
end