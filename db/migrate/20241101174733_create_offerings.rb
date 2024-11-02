class CreateOfferings < ActiveRecord::Migration[7.2]
  def change
    create_table :offerings do |t|
      t.string :description, null: false
      t.decimal :price, null: false
      t.references :offerable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
