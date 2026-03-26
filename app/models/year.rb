class Year < ApplicationRecord
  has_many :camps
  has_many :camp_applications, dependent: :destroy

  before_save :ensure_only_one_active_year

  private

  def ensure_only_one_active_year
    if registration_open?
      Year.where.not(id: id).update_all(registration_open: false)
    end
  end
end
