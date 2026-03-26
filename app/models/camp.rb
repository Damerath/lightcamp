class Camp < ApplicationRecord
  belongs_to :year
  has_many :camp_applications, dependent: :destroy
  has_many :camp_application_choices, dependent: :destroy
  has_many :camp_applications, through: :camp_application_choices
end
