class CampApplication < ApplicationRecord
  TEAM_OPTIONS = [
    "Prediger",
    "Programmleiter",
    "Gruppenleiter",
    "Sport",
    "Fotograf",
    "Videograf",
    "DIY (Basteln & Bauen)",
    "Techniker",
    "Küche",
    "Spüli",
    "Krankenpfleger/-in",
    "Musikverantwortlicher",
    "Freizeitleiter",
    "Campstory schreiben"
  ].freeze

  belongs_to :user
  belongs_to :year
  belongs_to :assigned_camp, class_name: "Camp", optional: true
  has_many :camp_application_choices, dependent: :destroy
  has_many :camps, through: :camp_application_choices

  validate :assigned_camp_matches_application
  validates :assigned_team, inclusion: { in: TEAM_OPTIONS }, allow_blank: true
  validate :assigned_team_requires_assigned_camp

  def confirmed?
    assigned_camp.present?
  end

  private

  def assigned_camp_matches_application
    return if assigned_camp.blank?
    return if camps.exists?(id: assigned_camp.id) && assigned_camp.year_id == year_id

    errors.add(:assigned_camp, "muss zu den ausgewaehlten Camps dieses Jahres gehoeren")
  end

  def assigned_team_requires_assigned_camp
    return if assigned_team.blank? || assigned_camp.present?

    errors.add(:assigned_team, "kann erst gesetzt werden, wenn ein Camp zugeteilt ist")
  end
end
