class AddLogoToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :logo, :string
    add_column :products, :icon, :string
  end
end
