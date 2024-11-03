class RenameColumnEffectiveDateOnTimeHistories < ActiveRecord::Migration[7.2]
  def change
    rename_column :price_histories, :effective_date, :effective_at
  end
end
