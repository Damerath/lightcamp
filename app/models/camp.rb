class Camp < ApplicationRecord
  DEFAULT_SLEEPING_PLACES = [
    { name: "Bungalow 1", capacity: 4, details: "Familie" },
    { name: "Bungalow 2", capacity: 4, details: "Familie" },
    { name: "Wohnung", capacity: 6, details: "Familie" },
    { name: "100", capacity: 3, details: nil },
    { name: "101", capacity: 3, details: nil },
    { name: "207", capacity: 6, details: nil },
    { name: "208", capacity: 4, details: nil },
    { name: "209", capacity: 4, details: nil },
    { name: "210", capacity: 4, details: nil },
    { name: "211", capacity: 4, details: nil },
    { name: "212", capacity: 4, details: nil }
  ].freeze

  belongs_to :year
  has_many :camp_teams, dependent: :destroy
  has_many :camp_sleeping_places, dependent: :destroy
  has_many :camp_room_people, dependent: :destroy
  has_many :assigned_camp_applications, class_name: "CampApplication", foreign_key: :assigned_camp_id, dependent: :nullify
  has_many :camp_application_choices, dependent: :destroy
  has_many :camp_applications, through: :camp_application_choices

  after_create :create_default_teams

  validate :date_range_complete
  validate :end_on_not_before_start_on

  def scheduled?
    start_on.present? && end_on.present?
  end

  def day_range
    return [] unless scheduled?

    (start_on..end_on).to_a
  end

  def published_program_team
    camp_teams.find_by(name: "Programmleiter", week_plan_published: true)&.workspace_team
  end

  def week_plan_published?
    published_program_team.present?
  end

  def create_default_teams
    return if camp_teams.exists?

    CampTeam::DEFAULT_TEAM_CONFIGS.each_with_index do |attributes, index|
      camp_teams.create!(attributes.merge(position: index))
    end
  end

  def ensure_sleeping_places!
    DEFAULT_SLEEPING_PLACES.each_with_index do |attributes, index|
      place = camp_sleeping_places.find_or_initialize_by(name: attributes[:name])
      next unless place.new_record?

      place.assign_attributes(attributes.merge(position: index, custom: false))
      place.save!
    end
  end

  private

  def date_range_complete
    return if start_on.blank? && end_on.blank?
    return if start_on.present? && end_on.present?

    errors.add(:base, "Bitte Start- und Enddatum gemeinsam angeben")
  end

  def end_on_not_before_start_on
    return if start_on.blank? || end_on.blank?
    return if end_on >= start_on

    errors.add(:end_on, "muss am oder nach dem Startdatum liegen")
  end
end
