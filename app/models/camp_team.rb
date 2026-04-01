class CampTeam < ApplicationRecord
  MEDIA_TEAM_NAMES = ["Fotograf", "Videograf"].freeze
  YEAR_SHARED_TEAM_NAMES = ["Campstory"].freeze
  RESPONSIBLE_DESCRIPTION_TEAM_NAMES = ["Sport", "DIY", "Küche"].freeze
  PROGRAM_DEFAULT_BLOCKS = [
    ["07:30", "MA-Treff"],
    ["08:00", "Appell"],
    ["08:15", "Fruehstueck"],
    ["08:45", "Dienste"],
    ["10:15", "Verse"],
    ["11:00", "Einstieg/Bibelarbeiten"],
    ["12:00", "freier Sport / basteln"],
    ["13:00", "Mittagessen"],
    ["14:00", "freier Sport / basteln"],
    ["15:00", "Pflichtsport"],
    ["18:30", "Abendessen"],
    ["20:00", "Abendveranstaltung"],
    ["21:30", "Lagerfeuer + Snack"],
    ["23:00", "Nachtruhe"]
  ].freeze
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
  belongs_to :team_template, optional: true
  has_many :assigned_camp_applications, class_name: "CampApplication", foreign_key: :assigned_camp_team_id, dependent: :nullify
  has_many :camp_team_links, dependent: :destroy
  has_many :camp_team_todos, dependent: :destroy
  has_many :camp_team_shopping_items, dependent: :destroy
  has_many :camp_program_blocks, dependent: :destroy
  has_many :camp_program_week_days, dependent: :destroy
  has_many :camp_sport_day_plans, dependent: :destroy
  has_many :camp_sport_material_items, dependent: :destroy
  has_many :camp_sport_material_changes, dependent: :destroy
  has_many :camp_kitchen_day_plans, dependent: :destroy
  has_many :camp_diy_day_plans, dependent: :destroy
  has_one :camp_sport_tournament_plan, dependent: :destroy

  before_validation :assign_team_template

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

  def description
    custom_description.presence || team_template&.description
  end

  def responsible_description
    custom_responsible_description.presence || team_template&.responsible_description
  end

  def media_team?
    MEDIA_TEAM_NAMES.include?(name)
  end

  def year_shared_team?
    YEAR_SHARED_TEAM_NAMES.include?(name)
  end

  def program_team?
    name == "Programmleiter"
  end

  def sport_team?
    name == "Sport"
  end

  def kitchen_team?
    name == "Küche"
  end

  def diy_team?
    name == "DIY"
  end

  def camp_leader_team?
    name == "Freizeitleiter"
  end

  def supports_responsible_description?
    RESPONSIBLE_DESCRIPTION_TEAM_NAMES.include?(name)
  end

  def published_week_plan_source_team
    camp.published_program_team
  end

  def week_plan_available_for_view?
    program_team? || published_week_plan_source_team.present?
  end

  def workspace_label
    media_team? ? "Medien" : name
  end

  def workspace_team
    return self unless media_team? || year_shared_team?

    if media_team?
      workspace_teams.min_by do |team|
        [team.name == "Videograf" ? 0 : 1, team.id]
      end || self
    else
      workspace_teams.min_by do |team|
        [team.camp.name.to_s, team.id]
      end || self
    end
  end

  def workspace_team_ids
    workspace_teams.map(&:id)
  end

  def workspace_teams
    return [self] unless media_team? || year_shared_team?

    if media_team?
      camp.camp_teams.where(name: MEDIA_TEAM_NAMES).to_a
    else
      CampTeam.joins(:camp).where(name: name, camps: { year_id: camp.year_id }).to_a
    end
  end

  def assigned_workspace_applications
    CampApplication.where(assigned_camp_team_id: workspace_team_ids)
  end

  def ensure_program_default_blocks!
    return unless program_team?
    return if camp_program_blocks.exists?

    PROGRAM_DEFAULT_BLOCKS.each_with_index do |(time_string, title), index|
      hour, minute = time_string.split(":").map(&:to_i)
      camp_program_blocks.create!(
        title: title,
        starts_at_minutes: (hour * 60) + minute,
        position: index,
        visible_to_others: true,
        color: "blue"
      )
    end
  end

  def sync_program_week_days_to_schedule!
    return unless program_team?
    return unless camp.scheduled?

    legacy_days = camp_program_week_days.where(planned_on: nil).ordered.to_a
    existing_dates = camp_program_week_days.where.not(planned_on: nil).pluck(:planned_on)

    camp.day_range.each_with_index do |date, index|
      next if existing_dates.include?(date)

      legacy_day = legacy_days.shift
      if legacy_day.present?
        legacy_day.update_columns(planned_on: date, day_key: date.strftime("%A").downcase, position: index)
      end
    end
  end

  def program_week_day_for(date)
    camp_program_week_days.find_by(planned_on: date)
  end

  def shows_internal_meeting?
    !%w[Prediger Krankenpfleger/-in].include?(name)
  end

  def sync_sport_day_plans_to_schedule!
    return unless sport_team?
    return unless camp.scheduled?

    existing_dates = camp_sport_day_plans.pluck(:planned_on)

    camp.day_range.each_with_index do |date, index|
      next if existing_dates.include?(date)

      camp_sport_day_plans.create!(planned_on: date, position: index)
    end
  end

  def ensure_sport_tournament_plan!
    return unless sport_team?

    camp_sport_tournament_plan || create_camp_sport_tournament_plan!
  end

  def ensure_sport_material_items!
    return unless sport_team?
    return if camp_sport_material_items.exists?

    defaults = team_template&.team_template_sport_material_items&.ordered || TeamTemplateSportMaterialItem.none

    defaults.each do |item|
      camp_sport_material_items.create!(
        name: item.name,
        quantity: item.quantity,
        storage_location: item.storage_location,
        position: item.position
      )
    end
  end

  def sport_material_manager?(user)
    return false unless sport_team? && user.present?

    user.camp_applications.exists?(assigned_camp_team_id: workspace_team_ids, assigned_as_responsible: true)
  end

  def sync_kitchen_day_plans_to_schedule!
    return unless kitchen_team?
    return unless camp.scheduled?

    existing_dates = camp_kitchen_day_plans.pluck(:planned_on)

    camp.day_range.each_with_index do |date, index|
      next if existing_dates.include?(date)

      camp_kitchen_day_plans.create!(planned_on: date, position: index)
    end
  end

  def sync_diy_day_plans_to_schedule!
    return unless diy_team?
    return unless camp.scheduled?

    existing_dates = camp_diy_day_plans.pluck(:planned_on)

    camp.day_range.each_with_index do |date, index|
      next if existing_dates.include?(date)

      camp_diy_day_plans.create!(planned_on: date, position: index)
    end
  end

  private

  def assign_team_template
    return if name.blank?

    self.team_template = TeamTemplate.find_or_create_by!(name: name)
  end

  def gender_slots_within_capacity
    return if male_slots + female_slots <= capacity

    errors.add(:base, "Maennliche und weibliche Plaetze duerfen zusammen die Gesamtplaetze nicht uebersteigen")
  end

  def responsible_slots_within_capacity
    return if responsible_slots <= capacity

    errors.add(:responsible_slots, "duerfen die Gesamtplaetze nicht uebersteigen")
  end
end
