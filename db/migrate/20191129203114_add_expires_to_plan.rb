class AddExpiresToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :expires, :datetime
  end
end
