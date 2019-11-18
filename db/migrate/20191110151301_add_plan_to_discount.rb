class AddPlanToDiscount < ActiveRecord::Migration[6.0]
  def change
    add_reference :discounts, :plan, null: false, foreign_key: true
  end
end
