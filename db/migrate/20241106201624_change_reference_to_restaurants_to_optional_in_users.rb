class ChangeReferenceToRestaurantsToOptionalInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :restaurant_id, true
  end
end