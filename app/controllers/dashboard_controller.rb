class DashboardController < ApplicationController
  def index
    @active_year = Year.find_by(registration_open: true)
    assigned_team_applications = current_user.camp_applications
      .includes(assigned_camp: :year, assigned_camp_team: :camp)
      .where.not(assigned_camp_team_id: nil)
      .sort_by { |application| [application.assigned_camp.year.name.to_s, application.assigned_camp.name.to_s, application.assigned_camp_team.name.to_s] }

    @active_assigned_team_applications =
      if @active_year.present?
        assigned_team_applications.select { |application| application.assigned_camp.year_id == @active_year.id }
      else
        []
      end

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
