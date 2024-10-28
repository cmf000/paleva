class AddEmailToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :email, :string, null:false
  end
end
