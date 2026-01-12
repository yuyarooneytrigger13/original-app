class AvailabilitiesController < ApplicationController
  before_action :set_plan, only: [:index, :new, :create, :edit, :update]

  def index
    @candidates = @plan.candidates.includes(:availabilities)
    @new_candidate = Candidate.new
    @users = User.where(id: Availability.where(candidate_id: @candidates.ids).select(:user_id))
                 .or(User.where(id: current_user.id)).distinct

    member_count = @users.count > 0 ? @users.count : 1
    @perfect_candidates = @candidates.select do |candidate|
      candidate.availabilities.select { |a| a.status == 'ok' }.count == member_count
    end
  end
  def new
    @availability = Availability.new

  end
  def create
  end

  def edit
    @candidates = @plan.candidates.includes(:availabilities).order(:date)
  end

  def update
    if params[:availabilities]
      params[:availabilities].each do |candidate_id, status|
        availability = Availability.find_or_initialize_by(candidate_id: candidate_id, user_id: current_user.id)
        availability.status = status
        availability.save
      end
      redirect_to plan_availabilities_path(@plan), notice: "回答を保存しました。"
    else
      redirect_to plan_availabilities_path(@plan), alert: "回答が送信されませんでした。"
    end
  end

  def destroy
    
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
