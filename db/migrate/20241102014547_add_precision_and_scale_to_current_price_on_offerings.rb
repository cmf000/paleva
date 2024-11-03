class AddPrecisionAndScaleToCurrentPriceOnOfferings < ActiveRecord::Migration[7.2]
  def change
    change_column :offerings, :current_price, :decimal, precision: 10, scale: 2, null: false
  end
end
