class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :nickname, presence: true
  has_many :availabilities
  has_many :visited_records, dependent: :destroy
  has_many :plans, dependent: :destroy
  
  has_many :plan_users, dependent: :destroy
  has_many :participating_plans, through: :plan_users, source: :plan

  # 自分が作成した計画と参加している計画を合わせたスコープ
  def related_plans
    Plan.left_joins(:plan_users)
        .where("plans.user_id = ? OR plan_users.user_id = ?", id, id)
        .distinct
  end

  # 一番直近の計画を取得する
  def latest_plan
    today_int = Date.today.strftime('%Y%m%d').to_i
    
    # 1. 未来の計画（日付が近い順）
    upcoming = related_plans.where("confirmed_date >= ?", today_int).order(:confirmed_date).first
    return upcoming if upcoming

    # 2. 日付未定の計画（更新が新しい順）
    undecided = related_plans.where(confirmed_date: nil).order(updated_at: :desc).first
    return undecided if undecided

    # 3. 過去の計画（日付が新しい順）
    related_plans.where("confirmed_date < ?", today_int).order(confirmed_date: :desc).first
  end
end
