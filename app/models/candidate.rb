class Candidate < ApplicationRecord
  belongs_to :plan
  has_many :availabilities, dependent: :destroy
end
