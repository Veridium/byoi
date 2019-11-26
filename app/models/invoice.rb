class Invoice < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  belongs_to :discount
end
