class Plan < ApplicationRecord
  has_many :destinations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :candidates, dependent: :destroy
  belongs_to :user
end
