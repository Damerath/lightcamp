class Year < ApplicationRecord
  has_many :camps
  has_many :camp_applications, dependent: :destroy

  before_save :ensure_only_one_active_year

  validate :training_on_required

  private

  def ensure_only_one_active_year
    if registration_open?
      Year.where.not(id: id).update_all(registration_open: false)
    end
  end

  def training_on_required
    return if training_on.present?
    return if persisted? && changes_to_save.keys == ["registration_open"]

    errors.add(:training_on, "muss ausgewaehlt werden")
  end
end
