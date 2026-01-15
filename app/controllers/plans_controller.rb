class PlansController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_plan, only: [:show]

  def index
    today_int = Date.today.strftime('%Y%m%d').to_i
    @upcoming_plans = current_user.plans.where("confirmed_date >= ? OR confirmed_date IS NULL", today_int).order(:confirmed_date)
    @past_plans = current_user.plans.where("confirmed_date < ?", today_int).order(confirmed_date: :desc)
  end


  def show
    @candidates = @plan.candidates.includes(:availabilities).order(:date)
    @users = User.where(id: Availability.where(candidate_id: @candidates.ids).select(:user_id))
                 .or(User.where(id: current_user.id)).distinct
    member_count = @users.count > 0 ? @users.count : 1
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

  private
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :status, :confirmed_date)
  end
end
