class DownloadItem < ApplicationRecord
  enum :scope_kind, { admin_only: 0, team_template_default: 1, camp_team_local: 2 }

  belongs_to :team_template, optional: true
  belongs_to :camp_team, optional: true
  belongs_to :uploader, class_name: "User", optional: true
  has_one_attached :file

  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :scope_associations_match
  validate :file_must_be_attached

  scope :ordered, -> { order(:position, :title, :id) }
  scope :admin_items, -> { admin_only.ordered }
  scope :default_for_template, ->(team_template) { team_template_default.where(team_template: team_template).ordered }
  scope :local_for_team, ->(camp_team) { camp_team_local.where(camp_team: camp_team).ordered }

  private

  def scope_associations_match
    case scope_kind
    when "admin_only"
      errors.add(:team_template, "muss leer sein") if team_template_id.present?
      errors.add(:camp_team, "muss leer sein") if camp_team_id.present?
    when "team_template_default"
      errors.add(:team_template, "muss gesetzt sein") if team_template_id.blank?
      errors.add(:camp_team, "muss leer sein") if camp_team_id.present?
    when "camp_team_local"
      errors.add(:camp_team, "muss gesetzt sein") if camp_team_id.blank?
      errors.add(:team_template, "muss leer sein") if team_template_id.present?
    end
  end

  def file_must_be_attached
    errors.add(:file, "muss ausgewählt werden") unless file.attached?
  end
end
