class CampSleepingPlace < ApplicationRecord
  belongs_to :camp
  has_many :camp_applications, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :camp_id }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :name) }

  def occupancy_count
    camp_applications.count
  end

  def family_only?
    details.to_s.downcase.include?("familie")
  end
end
