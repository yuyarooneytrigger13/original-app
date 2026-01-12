class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :candidate

  enum status: { ng: 0, maybe: 1, ok: 2 }
end
