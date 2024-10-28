class ChangeBeverageAlcoholicToRequired < ActiveRecord::Migration[7.2]
  def change
    change_column_null :beverages, :alcoholic, false
  end
end
