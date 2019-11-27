class AddFingerprintToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :fingerprint, :string
  end
end
