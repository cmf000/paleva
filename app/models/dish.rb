class Dish < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image
  attr_accessor :remove_image
  validates :name, :description, presence: true
  validates :calories, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
end
