class AddDistrictToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :district, :string, null: false
  end
end
