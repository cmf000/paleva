class OrderOffering < ApplicationRecord
  belongs_to :offering
  belongs_to :order

  def total_price
    self.offering.current_price * self.quantity
  end
end
