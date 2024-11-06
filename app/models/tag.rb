class Tag < ApplicationRecord
  has_many :offerable_tags, dependent: :destroy
  has_many :offerables, through: :offerable_tags
  validates :name, uniqueness: true, presence: true
end
