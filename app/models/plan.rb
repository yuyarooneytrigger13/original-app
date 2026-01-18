class Plan < ApplicationRecord
  has_many :destinations, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :candidates, dependent: :destroy
  has_many :availabilities, through: :candidates
  belongs_to :user

  # 参加メンバーとの関連付けを追加
  has_many :plan_users, dependent: :destroy
  has_many :users, through: :plan_users
end
