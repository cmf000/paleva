class CreateNewEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :new_employees do |t|
      t.string :email, null: false
      t.string :cpf, null: false

      t.timestamps
    end
  end
end
