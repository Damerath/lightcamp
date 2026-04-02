class TeamTemplate < ApplicationRecord
  has_many :camp_teams, dependent: :nullify
  has_many :team_template_links, dependent: :destroy
  has_many :team_template_sport_material_items, dependent: :destroy
  has_many :team_template_sport_material_changes, dependent: :destroy
  has_many :download_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def sport_team?
    name == "Sport"
  end

  def supports_responsible_description?
    CampTeam::RESPONSIBLE_DESCRIPTION_TEAM_NAMES.include?(name)
  end

  def apply_default_change!(scope:, old_description:, old_responsible_description:, active_year: nil)
    relation = camp_teams.includes(:camp)

    case scope
    when "all"
      relation.find_each do |camp_team|
        camp_team.update!(
          custom_description: nil,
          custom_responsible_description: nil
        )
      end
    when "future_years"
      future_year_ids = eligible_year_ids_for(scope, active_year)

      relation.find_each do |camp_team|
        if future_year_ids.include?(camp_team.camp.year_id)
          camp_team.update!(
            custom_description: nil,
            custom_responsible_description: nil
          )
        else
          attributes = {}
          attributes[:custom_description] = old_description if camp_team.custom_description.blank?

          if supports_responsible_description? && camp_team.custom_responsible_description.blank?
            attributes[:custom_responsible_description] = old_responsible_description
          end

          camp_team.update!(attributes) if attributes.present?
        end
      end
    end
  end

  private

  def eligible_year_ids_for(scope, active_year)
    return Year.pluck(:id) unless scope == "future_years"
    return [] if active_year.blank?

    active_year_value = year_sort_value(active_year)

    Year.all.select { |year| year_sort_value(year) > active_year_value }.map(&:id)
  end

  def year_sort_value(year)
    Integer(year.name, exception: false) || year.id
  end
end
