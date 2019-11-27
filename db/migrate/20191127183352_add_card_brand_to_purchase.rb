class AddCardBrandToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :cardbrand, :string
  end
end
