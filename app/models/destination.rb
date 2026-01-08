class Destination < ApplicationRecord
  belongs_to :plan
  has_one_attached :image
  belongs_to :user
end
