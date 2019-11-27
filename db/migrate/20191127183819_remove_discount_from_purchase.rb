class RemoveDiscountFromPurchase < ActiveRecord::Migration[6.0]
  def change
    remove_reference :purchases, :discount, null: false, foreign_key: true
  end
end
