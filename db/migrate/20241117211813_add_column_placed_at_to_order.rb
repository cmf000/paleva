class AddColumnPlacedAtToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :placed_at, :datetime
  end
end
