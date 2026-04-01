class TeamTemplateSportMaterialChange < ApplicationRecord
  belongs_to :team_template
  belongs_to :user, optional: true

  validates :actor_name, :material_name, :change_type, :change_summary, presence: true

  scope :recent_first, -> { order(created_at: :desc, id: :desc) }

  def self.log!(team_template:, user:, material_name:, change_type:, change_summary:)
    create!(
      team_template: team_template,
      user: user,
      actor_name: actor_name_for(user),
      material_name: material_name,
      change_type: change_type,
      change_summary: change_summary
    )
  end

  def self.actor_name_for(user)
    return "System" if user.blank?

    user.respond_to?(:display_name) ? user.display_name : ([user.first_name, user.last_name].compact.join(" ").presence || user.email)
  end
end
