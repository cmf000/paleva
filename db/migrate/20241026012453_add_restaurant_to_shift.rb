class AddRestaurantToShift < ActiveRecord::Migration[7.2]
  def change
    add_reference :shifts, :restaurant, null: false, foreign_key: true
  end
end
