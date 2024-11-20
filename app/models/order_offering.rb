class OrderOffering < ApplicationRecord
  belongs_to :offering
  belongs_to :order
  validate :offering_belongs_to_active_offerable
  validate :offerable_must_be_added_through_a_menu

  def total_price
    self.offering.current_price * self.quantity
  end

  def offering_description
    self.offering.description
  end

  def item_name
    self.offering.offerable.name
  end

  private
  def offering_belongs_to_active_offerable
    if self.offering.offerable.inactive?
      errors.add(:offering, "deve pertencer a um item ativo")
    end
  end

  def offerable_must_be_added_through_a_menu
    if self.offering.offerable.menus.empty?
      errors.add(:offering, ' deve fazer parte de um cardápio')
    end
  end
end
