class Offering < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  has_many :price_histories, dependent: :destroy
  has_many :order_offerings, dependent: :destroy
  has_many :orders, through: :order_offerings
  validates :offerable_id, :description, :current_price, :effective_at, presence: true
  validates :current_price, numericality: { greater_than: 0 }
  before_validation :set_effective_at
  after_update :update_price_history
  validate :new_price_must_be_different

  private

  def new_price_must_be_different
    if current_price == current_price_was
      errors.add(:current_price, "só pode ser alterado para um valor diferente")
    end
  end

  def set_effective_at
    if will_save_change_to_current_price?
      self.effective_at = DateTime.now
    end
  end

  def update_price_history
    if self.previous_changes[:current_price].present?
      self.price_histories.create!(price: self.previous_changes[:current_price][0], effective_at: self.previous_changes[:effective_at][0])
    end
  end
end
