class SchedulesController < ApplicationController
  before_action :set_plan

  def index
  @schedules = @plan.schedules.order(:start_time)
  end

  def new
  @schedule = @plan.schedules.build
  @schedule.start_time = Time.current
  end

  def create
    @schedule = @plan.schedules.build(schedule_params)
    
    if @schedule.save
      redirect_to plan_schedules_path(@plan), notice: '予定を追加しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule = @plan.schedules.find(params[:id])
    @schedule.destroy
    redirect_to plan_schedules_path(@plan), notice: '削除しました', status: :see_other
  end

  private
  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
  def schedule_params
    params.require(:schedule).permit(:title, :start_time, :memo)
  end


end
