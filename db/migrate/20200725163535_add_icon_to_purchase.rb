class AddIconToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :icon, :string
  end
end
