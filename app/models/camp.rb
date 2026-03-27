class Camp < ApplicationRecord
  belongs_to :year
  has_many :camp_teams, dependent: :destroy
  has_many :assigned_camp_applications, class_name: "CampApplication", foreign_key: :assigned_camp_id, dependent: :nullify
  has_many :camp_application_choices, dependent: :destroy
  has_many :camp_applications, through: :camp_application_choices

  after_create :create_default_teams

  def create_default_teams
    return if camp_teams.exists?

    CampTeam::DEFAULT_TEAM_CONFIGS.each_with_index do |attributes, index|
      camp_teams.create!(attributes.merge(position: index))
    end
  end
end
