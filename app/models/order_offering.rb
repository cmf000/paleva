class OrderOffering < ApplicationRecord
  belongs_to :offering
  belongs_to :order
  validate :offering_belongs_to_active_offerable

  def total_price
    self.offering.current_price * self.quantity
  end

  private
  def offering_belongs_to_active_offerable
    if self.offering.offerable.inactive?
      errors.add(:offering, "deve pertencer a um item ativo")
    end
  end
end
