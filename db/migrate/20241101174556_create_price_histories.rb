class CreatePriceHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :price_histories do |t|
      t.decimal :price, null: false
      t.datetime :effective_date, null: false
      t.references :offering, null: false, foreign_key: true

      t.timestamps
    end
  end
end
