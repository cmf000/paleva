class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :offerable_menus, dependent: :destroy
  has_many :dishes,    through: :offerable_menus, source: :offerable, source_type: 'Dish'
  has_many :beverages, through: :offerable_menus, source: :offerable, source_type: 'Beverage' 

  validates :name, presence: true, uniqueness: { case_sensitive: false}
 
end
