class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :phone_number
      t.string :email
      t.string :cpf
      t.integer :status
      t.string :code

      t.timestamps
    end
  end
end
