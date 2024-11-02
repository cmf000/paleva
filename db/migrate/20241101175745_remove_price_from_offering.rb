class RemovePriceFromOffering < ActiveRecord::Migration[7.2]
  def change
    remove_column :offerings, :price, :decimal 
  end
end
