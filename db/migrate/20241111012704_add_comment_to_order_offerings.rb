class AddCommentToOrderOfferings < ActiveRecord::Migration[7.2]
  def change
    add_column :order_offerings, :comment, :string
  end
end
