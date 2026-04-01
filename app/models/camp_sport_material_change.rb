class CampSportMaterialChange < ApplicationRecord
  belongs_to :camp_team
  belongs_to :user, optional: true

  validates :actor_name, :material_name, :change_type, :change_summary, presence: true

  scope :recent_first, -> { order(created_at: :desc, id: :desc) }

  def self.log!(camp_team:, user:, material_name:, change_type:, change_summary:)
    create!(
      camp_team: camp_team,
      user: user,
      actor_name: actor_name_for(user),
      material_name: material_name,
      change_type: change_type,
      change_summary: change_summary
    )
  end

  def self.actor_name_for(user)
    return "System" if user.blank?

    [user.first_name, user.last_name].compact.join(" ").presence || user.email
  end
end
