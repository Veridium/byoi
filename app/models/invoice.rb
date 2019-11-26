class Invoice < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  belongs_to :discount, optional: true

  monetize :rebate_cents
  monetize :total_cents
end
