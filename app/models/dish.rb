class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :offerings,       as: :offerable, dependent: :destroy
  has_many :offerable_tags,  as: :offerable, dependent: :destroy
  has_many :offerable_menus, as: :offerable, dependent: :destroy
  has_many :tags,            as: :offerable, through: :offerable_tags
  has_many :menus,           as: :offerable, through: :offerable_menus
  has_one_attached :image
  enum :status, [:inactive, :active]
  attr_accessor :remove_image
  validates :name, :description, presence: true
  validates :calories, numericality: {greater_than_or_equal_to: 0}, allow_blank: true

end
