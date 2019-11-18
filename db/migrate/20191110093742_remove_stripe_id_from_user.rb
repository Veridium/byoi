class RemoveStripeIdFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :stripe_id
  end
end
