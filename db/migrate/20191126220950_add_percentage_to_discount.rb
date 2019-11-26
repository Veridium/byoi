class AddPercentageToDiscount < ActiveRecord::Migration[6.0]
  def change
    add_column :discounts, :percentage, :integer
  end
end
