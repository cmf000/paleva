class AddPhoneNumberToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurants, :phone_number, :string, null: false
  end
end
