class Beverage < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image
  attr_accessor :remove_image
  validates :name, :description, presence: true
  validates :alcoholic, presence: {message: "deve ser sim/não"}
  validates :calories, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  enum alcoholic: { no: 0, yes: 1 }
  enum :status, [:inactive, :active]

end
