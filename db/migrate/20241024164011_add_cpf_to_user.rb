class AddCpfToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :cpf, :string
  end
end
