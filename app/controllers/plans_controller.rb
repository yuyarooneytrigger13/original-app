class PlansController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_plan, only: [:show, :destroy, :update]

  def index
    today_int = Date.today.strftime('%Y%m%d').to_i
    # 自分が作成した計画 または 参加している計画 を取得
    if user_signed_in?
      plans = Plan.left_joins(:plan_users)
                  .where("plans.user_id = ? OR plan_users.user_id = ?", current_user.id, current_user.id)
                  .distinct
                  .includes(:users, :user)

      @upcoming_plans = plans.where("confirmed_date >= ? OR confirmed_date IS NULL", today_int).order(:confirmed_date)
      @past_plans = plans.where("confirmed_date < ?", today_int).order(confirmed_date: :desc)
    else
      @upcoming_plans = Plan.none
      @past_plans = Plan.none
    end
  end


  def show
    @candidates = @plan.candidates.includes(:availabilities).order(:date)
    
    invited_ids = @plan.plan_users.pluck(:user_id)
    all_ids = (invited_ids + [@plan.user_id]).uniq
    member_count = User.where(id: all_ids).count
    @perfect_candidates = @candidates.select do |candidate|
      candidate.availabilities.select { |a| a.status == 'ok' }.count == member_count
    end
    # 行きたい場所リスト
    @destinations = @plan.try(:destinations)&.limit(4) || []
  end

  def new
    @plan = Plan.new
    if params[:confirmed_date].present?
      @plan.confirmed_date = params[:confirmed_date].to_s.gsub('-', '').to_i
    end
  end

  def create
    @plan = current_user.plans.new(plan_params)
    if @plan.save
      redirect_to plan_path(@plan), notice: '旅行計画を作成しました。'
    else
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      if @plan.saved_change_to_confirmed_date?
        redirect_to plan_path(@plan), notice: "日程が決定しました！"
      else
        redirect_to plan_path(@plan), notice: "プランを更新しました"
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @plan.destroy
    redirect_to plans_path, notice: "「#{@plan.title}」を削除しました。"
  end

  private
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    permitted = params.require(:plan).permit(:title, :status, :confirmed_date)
    if permitted[:confirmed_date].present?
      permitted[:confirmed_date] = permitted[:confirmed_date].to_s.gsub('-', '').to_i
    end
    permitted
  end
end
