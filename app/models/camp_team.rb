class CampTeam < ApplicationRecord
  DEFAULT_TEAM_CONFIGS = [
    { name: "Freizeitleiter", capacity: 2, male_slots: 1, female_slots: 1 },
    { name: "Programmleiter", capacity: 2, male_slots: 1, female_slots: 1 },
    { name: "Prediger", capacity: 1, male_slots: 1, female_slots: 0 },
    { name: "Gruppenleiter", capacity: 10, male_slots: 5, female_slots: 5 },
    { name: "Sport", capacity: 4, responsible_slots: 1 },
    { name: "DIY", capacity: 3, responsible_slots: 1 },
    { name: "Küche", capacity: 7, responsible_slots: 1 },
    { name: "Fotograf", capacity: 1 },
    { name: "Videograf", capacity: 2 },
    { name: "Techniker", capacity: 1 },
    { name: "Spüli", capacity: 2 },
    { name: "Musikverantwortlicher", capacity: 1 },
    { name: "Krankenpfleger/-in", capacity: 1 },
    { name: "Campstory", capacity: 1 }
  ].freeze

  belongs_to :camp
  has_many :assigned_camp_applications, class_name: "CampApplication", foreign_key: :assigned_camp_team_id, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :camp_id }
  validates :capacity, :male_slots, :female_slots, :responsible_slots, :position,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :gender_slots_within_capacity
  validate :responsible_slots_within_capacity

  scope :ordered, -> { order(:position, :name) }

  def assigned_count
    assigned_camp_applications.count
  end

  def assigned_responsible_count
    assigned_camp_applications.where(assigned_as_responsible: true).count
  end

  def assigned_male_count
    assigned_camp_applications.joins(:user).where(users: { gender: "male" }).count
  end

  def assigned_female_count
    assigned_camp_applications.joins(:user).where(users: { gender: "female" }).count
  end

  private

  def gender_slots_within_capacity
    return if male_slots + female_slots <= capacity

    errors.add(:base, "Maennliche und weibliche Plaetze duerfen zusammen die Gesamtplaetze nicht uebersteigen")
  end

  def responsible_slots_within_capacity
    return if responsible_slots <= capacity

    errors.add(:responsible_slots, "duerfen die Gesamtplaetze nicht uebersteigen")
  end
end
