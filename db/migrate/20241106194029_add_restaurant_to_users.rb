class AddRestaurantToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :restaurant, null: true, foreign_key: true
  end
end
