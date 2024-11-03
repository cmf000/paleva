class AddEffectiveAtOnOfferings < ActiveRecord::Migration[7.2]
  def change
    add_column :offerings, :effective_at, :datetime, null: false
  end
end
