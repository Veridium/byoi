class AddExpiresToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :expires, :datetime
  end
end
