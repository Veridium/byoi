class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :invoice
  belongs_to :plan
  monetize :amount_cents
end
