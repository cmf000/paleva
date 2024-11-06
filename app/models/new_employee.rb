class NewEmployee < ApplicationRecord
  belongs_to :restaurant
  validates :cpf, :email, presence: true
  validates :cpf, :email, uniqueness: true
  validates :email, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/}, if: -> { email.present? }
  validate :cpf_and_email_must_be_unique_in_users
  validate :cpf, :validate_cpf, if: -> { cpf.present? }

  private
  def cpf_and_email_must_be_unique_in_users
    if User.exists?(cpf: self.cpf)
      errors.add(:cpf, :exists)
    end

    if User.exists?(email: self.email)
      errors.add(:email, :exists)
    end
  end

  def validate_cpf
    errors.add(:cpf, :invalid) unless CPF.valid?(self.cpf, strict: true)
  end
end
