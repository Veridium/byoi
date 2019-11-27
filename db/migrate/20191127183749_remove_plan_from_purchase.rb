class RemovePlanFromPurchase < ActiveRecord::Migration[6.0]
  def change
    remove_reference :purchases, :plan, null: false, foreign_key: true
  end
end
