class CreateBeverages < ActiveRecord::Migration[7.2]
  def change
    create_table :beverages do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :calories

      t.timestamps
    end
  end
end
