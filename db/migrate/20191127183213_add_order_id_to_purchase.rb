class AddOrderIdToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :order_id, :string
  end
end
