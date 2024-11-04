class OfferableTag < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  belongs_to :tag
end
