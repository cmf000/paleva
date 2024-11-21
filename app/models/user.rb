class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  enum user_type: [:owner, :employee]

  has_one :owned_restaurant,       class_name: 'Restaurant', dependent: :destroy
  belongs_to :works_at_restaurant, class_name: 'Restaurant', foreign_key: :restaurant_id, optional: true
  validate :owner_cannot_work_at_restaurant
  validate :employee_cannot_own_restaurant

  validates :name, :cpf, :email, presence: true
  validates :cpf, uniqueness: true
  validate :validate_cpf
  validate :check_registered_new_employees, on: :create

  before_create :determine_user_type
  after_create :destroy_new_employee

  private
  def owner_cannot_work_at_restaurant
    if owner? && self.works_at_restaurant.present?
      errors.add(:restaurant_id, :invalid)
    end
  end

  def employee_cannot_own_restaurant
    if employee? && self.owned_restaurant.present?
      errors.add(:user_type, "não pode ser dono de restaurante")
    end
  end
  
  def validate_cpf
    return if CPF.valid?(self.cpf, strict: true)
    errors.add(:cpf, :invalid)
  end

  def check_registered_new_employees
    new_employee_cpf_match = NewEmployee.find_by(cpf: self.cpf)
    new_employee_email_match = NewEmployee.find_by(email: self.email)
    if (new_employee_cpf_match.present? ^ new_employee_email_match.present?) || 
       (new_employee_cpf_match != new_employee_email_match)
      errors.add(:email, :invalid)
      errors.add(:cpf, :invalid)
    end
  end

  def determine_user_type
    new_employee = NewEmployee.find_by(cpf: self.cpf)

    if new_employee.present?
      self.user_type = :employee
      self.works_at_restaurant = new_employee.restaurant
      @new_employee_to_destroy = new_employee
    else
      self.user_type = :owner
    end
  end

  def destroy_new_employee
    if @new_employee_to_destroy.present?
      @new_employee_to_destroy.destroy
    end
  end
end
