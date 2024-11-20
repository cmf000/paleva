class AddColumnCancellationNotToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :cancelation_note, :string
  end
end
