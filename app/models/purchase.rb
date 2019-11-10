class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  belongs_to :discount
end
