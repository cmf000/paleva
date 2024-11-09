class CreateOfferableMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :offerable_menus do |t|
      t.references :offerable, polymorphic: true, null: false
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
