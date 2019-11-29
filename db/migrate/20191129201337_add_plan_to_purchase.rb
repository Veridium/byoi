class AddPlanToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_reference :purchases, :plan, null: false, foreign_key: true
  end
end
