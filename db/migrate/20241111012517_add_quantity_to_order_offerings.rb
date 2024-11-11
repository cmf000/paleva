class AddQuantityToOrderOfferings < ActiveRecord::Migration[7.2]
  def change
    add_column :order_offerings, :quantity, :integer, null: false, default: 1
  end
end
