class AddRestaurantIdToNewEmployee < ActiveRecord::Migration[7.2]
  def change
    add_reference :new_employees, :restaurant, null: false, foreign_key: true
  end
end
