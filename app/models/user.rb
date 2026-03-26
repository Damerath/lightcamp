class User < ApplicationRecord
  has_many :camp_applications, dependent: :destroy

  after_initialize :set_default_role, if: :new_record?

  def admin?
    role == "admin"
  end
  
  def profile_complete?
    first_name.present? &&
    last_name.present? &&
    gender.present? &&
    birthdate.present? &&
    phone.present?
  end

  private

  def set_default_role
    self.role ||= "user"
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
