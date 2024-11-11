class CreateOrderOfferings < ActiveRecord::Migration[7.2]
  def change
    create_table :order_offerings do |t|
      t.references :offering, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
