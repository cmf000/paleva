class OfferableTag < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  belongs_to :tag

  validates :tag_id, uniqueness: {scope: [:offerable_id, :offerable_type], message: "já está associada a este #{:offerable_type}"}
end
