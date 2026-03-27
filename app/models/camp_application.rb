class CampApplication < ApplicationRecord
  TEAM_OPTIONS = [
    "Prediger",
    "Programmleiter",
    "Gruppenleiter",
    "Sport",
    "Fotograf",
    "Videograf",
    "DIY",
    "Techniker",
    "Küche",
    "Spüli",
    "Krankenpfleger/-in",
    "Musikverantwortlicher",
    "Freizeitleiter",
    "Campstory"
  ].freeze

  belongs_to :user
  belongs_to :year
  belongs_to :assigned_camp, class_name: "Camp", optional: true
  belongs_to :assigned_camp_team, class_name: "CampTeam", optional: true
  has_many :camp_application_choices, dependent: :destroy
  has_many :camps, through: :camp_application_choices

  before_validation :sync_assignment_fields

  validate :assigned_camp_matches_application
  validate :assigned_camp_team_matches_application
  validate :assigned_as_responsible_allowed

  def confirmed?
    assigned_camp_team.present?
  end

  private

  def sync_assignment_fields
    if assigned_camp_team.present?
      self.assigned_camp = assigned_camp_team.camp
      self.assigned_team = assigned_camp_team.name
    elsif assigned_camp.blank?
      self.assigned_team = nil
      self.assigned_as_responsible = false
    end
  end

  def assigned_camp_matches_application
    return if assigned_camp.blank?
    return if camps.exists?(id: assigned_camp.id) && assigned_camp.year_id == year_id

    errors.add(:assigned_camp, "muss zu den ausgewaehlten Camps dieses Jahres gehoeren")
  end

  def assigned_camp_team_matches_application
    return if assigned_camp_team.blank?
    return if camps.exists?(id: assigned_camp_team.camp_id) && assigned_camp_team.camp.year_id == year_id

    errors.add(:assigned_camp_team, "muss zu einem ausgewaehlten Camp dieses Jahres gehoeren")
  end

  def assigned_as_responsible_allowed
    return unless assigned_as_responsible?
    return if assigned_camp_team.present? && assigned_camp_team.responsible_slots.positive?

    errors.add(:assigned_as_responsible, "ist fuer dieses Team nicht verfuegbar")
  end
end
