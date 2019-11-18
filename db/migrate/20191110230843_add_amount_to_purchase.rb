class AddAmountToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :amount_cents, :integer
    add_column :purchases, :currency, :string
  end
end
