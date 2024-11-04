class CreateOfferableTags < ActiveRecord::Migration[7.2]
  def change
    create_table :offerable_tags do |t|
      t.references :offerable, polymorphic: true, null: false
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
