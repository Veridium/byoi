class AddPaymentIdToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :payment_id, :string
  end
end
