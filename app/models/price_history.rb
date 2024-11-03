class PriceHistory < ApplicationRecord
  belongs_to :offering
  validates :price, :effective_at, presence: true

end
