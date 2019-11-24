class Member < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
