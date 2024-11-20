class OfferableTag < ApplicationRecord
  belongs_to :offerable, polymorphic: true
  belongs_to :tag

  validates :tag_id, uniqueness: {scope: [:offerable_id, :offerable_type], message: "já está associada a este #{:offerable_type}"}
  validate :tag_and_offerable_must_belong_to_same_restaurant

  private
  def tag_and_offerable_must_belong_to_same_restaurant
    if self.tag.restaurant != self.offerable.restaurant
      errors.add(:base, :invalid)
    end
  end
end
