class Restaurant < ApplicationRecord
  belongs_to :owner, -> { where(user_type: :owner) }, class_name: 'User', foreign_key: 'user_id'
  has_many :employees, -> { where(user_type: :employee) }, class_name: 'User'
  has_many :tags, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :beverages, dependent: :destroy
  has_many :dishes, dependent: :destroy
  has_many :new_employees, dependent: :destroy
  accepts_nested_attributes_for :shifts, allow_destroy: true

  validates :registered_name, :trade_name, :street_address, :district, :cnpj, 
            :city, :state, :zip_code, :code, :user_id, :email, :phone_number, presence: true
  validates :email, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/}
  validates :phone_number, length: {in: 10..11 }
  validate :validate_cnpj
  before_validation :set_code
  validates :code, :email, uniqueness: true
  validate :is_phone_number_numeric
  
  private
  def set_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def validate_cnpj
    if cnpj.present?
      unless CNPJ.valid?(self.cnpj, strict: true)
        errors.add(:cnpj, :invalid)
      end
    end
  end

  def is_phone_number_numeric
    if phone_number.present?
      unless self.phone_number =~ /^\d+$/
        errors.add(:phone_number, :invalid)
      end
    end
  end
end
