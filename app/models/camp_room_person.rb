class CampRoomPerson < ApplicationRecord
  KINDS = {
    "spouse" => "Ehepartner",
    "child" => "Kind",
    "guest" => "Gast",
    "other" => "Sonstiges"
  }.freeze

  belongs_to :camp
  belongs_to :camp_sleeping_place, optional: true
  belongs_to :related_camp_application, class_name: "CampApplication", optional: true

  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS.keys }

  scope :ordered, -> { order(:kind, :name) }

  def kind_label
    KINDS[kind] || kind
  end
end
