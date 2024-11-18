class Order < ApplicationRecord
  enum :status, [:draft, :pending_kitchen, :preparing, :cancelled, :ready, :delivered]
  has_many :order_offerings, dependent: :destroy
  has_many :offerings, through: :order_offerings
  belongs_to :restaurant

  validates :customer_name, presence: true
  validates :email, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/}, if: -> { email.present? }
  validate :is_cpf_valid, if: -> { self.cpf.present? }
  validate :email_or_phone_number_must_be_informed
  validate :is_phone_number_numeric, if: -> {self.phone_number.present? }
  validate :check_status_change, if: :status_changed?, unless: :new_record?
  validates :order_offerings, presence: { message:" - pedido precisa ter pelo menos um item para ser enviado à cozinha" }, 
                              if: :going_to_kitchen?

  before_validation :set_initial_status_to_draft, on: :create
  before_save :set_code, if: :going_to_kitchen?
  before_save :set_placed_at, if: :going_to_kitchen?

  def total_price
    self.order_offerings.sum(&:total_price)
  end

  private
  def email_or_phone_number_must_be_informed
    if self.email.blank? && self.phone_number.blank?
      errors.add(:base, 'É obrigatório informar Telefone ou E-mail')
    end 
  end

  def set_initial_status_to_draft
    self.status = :draft
  end

  def is_cpf_valid
    cpf = CPF.new(self.cpf)
    if !cpf.valid?
      errors.add(:cpf, :invalid)
    end
  end

  def is_phone_number_numeric
    if phone_number.present?
      unless self.phone_number =~ /^\d+$/
        errors.add(:phone_number, :invalid)
      end
    end
  end

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def going_to_kitchen?
    status_changed? && self.status == 'pending_kitchen'
  end

  def check_status_change
    if status_changed?
      current_status = I18n.t("activerecord.enums.order.status.#{status_was}")
      new_status = I18n.t("activerecord.enums.order.status.#{self.status}")
      if !(status_was == 'pending_kitchen' && self.status == 'preparing') &&
          !(status_was == 'preparing' && self.status == 'ready') &&
          !(status_was == 'draft' && self.status == 'pending_kitchen') &&
          !(status_was == 'ready' && self.status == 'delivered')

          errors.add(:status, "não pode mudar de #{current_status} para #{new_status}")
      end
    end
  end

  def set_placed_at
    self.placed_at = Time.zone.now
  end
end
