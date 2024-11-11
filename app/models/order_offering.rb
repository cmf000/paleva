class OrderOffering < ApplicationRecord
  belongs_to :offering
  belongs_to :order
end
