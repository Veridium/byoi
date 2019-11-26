class AddTotalToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :total_cents, :integer
  end
end
