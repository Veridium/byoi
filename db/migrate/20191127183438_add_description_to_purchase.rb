class AddDescriptionToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :description, :string
  end
end
