class Plan < ApplicationRecord
    belongs_to :product
    monetize :price_cents
end
