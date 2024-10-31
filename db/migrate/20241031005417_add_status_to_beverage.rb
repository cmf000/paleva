class AddStatusToBeverage < ActiveRecord::Migration[7.2]
  def change
    add_column :beverages, :status, :integer, default: 1
  end
end
