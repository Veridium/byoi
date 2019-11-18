class AddPriceToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :price_cents, :integer
  end
end
