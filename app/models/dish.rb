class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :offerings, as: :offerable,
                       dependent: :destroy
  has_one_attached :image
  enum :status, [:inactive, :active]
  attr_accessor :remove_image
  validates :name, :description, presence: true
  validates :calories, numericality: {greater_than_or_equal_to: 0}, allow_blank: true

end
