class AddRestaurantReferenceToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :restaurant, null: false, foreign_key: true
  end
end
