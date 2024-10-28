class AddAlcoholicMarkerToBeverage < ActiveRecord::Migration[7.2]
  def change
    add_column :beverages, :alcoholic, :integer
  end
end
