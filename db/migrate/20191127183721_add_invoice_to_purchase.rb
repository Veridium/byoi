class AddInvoiceToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchases, :invoice, null: false, foreign_key: true
  end
end
