class RemoveExpiresFromPlan < ActiveRecord::Migration[6.0]
  def change

    remove_column :plans, :expires, :datetime
  end
end
