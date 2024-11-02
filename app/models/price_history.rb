class PriceHistory < ApplicationRecord
  belongs_to :offering
  validates :price, :effective_date, presence: true

end
