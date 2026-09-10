class DataRetention
  HEALTH_DATA_RETENTION = 12.months
  APPLICATION_RETENTION = 12.months
  ARCHIVE_ANONYMIZATION_RETENTION = 3.years

  def self.run!(today: Date.current)
    new(today:).run!
  end

  def initialize(today:)
    @today = today
  end

  def run!
    remove_expired_health_data!
    delete_stale_unconfirmed_applications!
    anonymize_historical_applications!
  end

  private

  attr_reader :today

  def remove_expired_health_data!
    applications_with_latest_camp_ending_before(today - HEALTH_DATA_RETENTION).find_each do |application|
      next if application.health_data_deleted_at.present?

      application.update_columns(
        health_restrictions: false,
        health_restrictions_details: nil,
        health_data_deleted_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  def delete_stale_unconfirmed_applications!
    CampApplication.where(assigned_camp_team_id: nil)
      .where("created_at < ?", today - APPLICATION_RETENTION)
      .find_each(&:destroy!)
  end

  def anonymize_historical_applications!
    applications_with_latest_camp_ending_before(today - ARCHIVE_ANONYMIZATION_RETENTION).find_each do |application|
      next if application.anonymized_at.present?

      anonymize_room_people!(application)
      application.update_columns(
        archived_display_name: archive_name_for(application),
        user_id: nil,
        motivation: nil,
        commitment: nil,
        comment: nil,
        uncertain_until: nil,
        health_restrictions: false,
        health_restrictions_details: nil,
        health_data_deleted_at: application.health_data_deleted_at || Time.current,
        anonymized_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  def applications_with_latest_camp_ending_before(cutoff)
    CampApplication.joins(:camps)
      .group("camp_applications.id")
      .having("MAX(camps.end_on) < ?", cutoff)
  end

  def anonymize_room_people!(application)
    CampRoomPerson.where(related_camp_application: application).find_each do |person|
      person.destroy!
    end
  end

  def archive_name_for(application)
    return application.archived_display_name if application.archived_display_name.present?

    user = application.user
    return "Ehemalige Person" if user.blank?

    [user.first_name.presence, user.last_name.to_s.first.presence&.then { |initial| "#{initial}." }].compact.join(" ").presence || "Ehemalige Person"
  end
end
