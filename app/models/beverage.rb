class Beverage < ApplicationRecord
  belongs_to :restaurant
  has_many :offerings,       as: :offerable, dependent: :destroy
  has_many :offerable_tags,  as: :offerable, dependent: :destroy
  has_many :offerable_menus, as: :offerable, dependent: :destroy
  has_many :tags,            as: :offerable, through: :offerable_tags
  has_many :menus,           as: :offerable, through: :offerable_menus
  has_one_attached :image
  attr_accessor :remove_image
  validates :name, :description, presence: true
  validates :alcoholic, presence: {message: "deve ser sim/não"}
  validates :calories, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  enum alcoholic: { no: 0, yes: 1 }
  enum :status, [:inactive, :active]

end
