class Offering < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  has_many :price_histories, dependent: :destroy
  validates :offerable_id, :description, presence: true
  validate :has_at_least_one_price_history

  private
  def has_at_least_one_price_history
    errors.add(:price_history, "não pode ficar em branco") if self.price_histories.empty?
  end
end
