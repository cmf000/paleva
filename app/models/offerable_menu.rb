class OfferableMenu < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  belongs_to :menu

  validates :menu_id, uniqueness: {scope: [:offerable_id, :offerable_type], message: "já contém este #{:offerable_type}."}
end
