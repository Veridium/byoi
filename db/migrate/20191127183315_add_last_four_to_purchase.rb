class AddLastFourToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :lastfour, :string
  end
end
