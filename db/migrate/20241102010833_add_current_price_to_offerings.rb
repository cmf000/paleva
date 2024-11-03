class AddCurrentPriceToOfferings < ActiveRecord::Migration[7.2]
  def change
    add_column :offerings, :current_price, :decimal
  end
end
