class Plan < ApplicationRecord
  has_many :destinations
  has_many :schedules
end
