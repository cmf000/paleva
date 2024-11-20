class ChangeColumnInOrdersFromCancelationNoteToCancellationNote < ActiveRecord::Migration[7.2]
  def change
    rename_column :orders, :cancelation_note, :cancellation_note
  end
end
