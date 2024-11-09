class Tag < ApplicationRecord
  belongs_to :restaurant
  has_many :offerable_tags, dependent: :destroy
  has_many :dishes,       through: :offerable_tags, source: :offerable, source_type: 'Dish'
  has_many :beverages,    through: :offerable_tags, source: :offerable, source_type: 'Beverage'
  validates :name, uniqueness: true, presence: true
end