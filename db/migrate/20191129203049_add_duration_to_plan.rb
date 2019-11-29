class AddDurationToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :duration, :integer
  end
end
