class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :restaurant
  enum user_type: [:owner, :employee]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :cpf, uniqueness: true
  validate :validate_cpf
  
  private
  def validate_cpf
    return if CPF.valid?(self.cpf, strict: true)
    errors.add(:cpf, :invalid)
  end
end
