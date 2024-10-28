class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :registered_name, null: false
      t.string :trade_name, null: false
      t.string :cnpj, null: false
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :code, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
