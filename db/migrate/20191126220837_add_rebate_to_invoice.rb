class AddRebateToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :rebate_cents, :integer
  end
end
