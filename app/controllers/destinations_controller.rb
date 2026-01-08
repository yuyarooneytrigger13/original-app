class DestinationsController < ApplicationController
  before_action :set_plan
  before_action :set_destination, only: [:edit, :update, :destroy]

  def index
    @destinations = @plan.destinations.order(created_at: :desc)
  end

  def new
    @destination = @plan.destinations.build
  end

  def create
    @destination = @plan.destinations.build(destination_params)
    @destination.user_id = current_user.id
    if @destination.save
      redirect_to plan_destinations_path(@plan), notice: '追加しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @destination.update(destination_params)
      redirect_to plan_destinations_path(@plan), notice: '更新しました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @destination.destroy
    redirect_to plan_destinations_path(@plan), notice: '削除しました！'
  end

  def update_likes
  @destination = Destination.find(params[:id])
  @destination.increment!(:likes_count)

  @plan = Plan.find(params[:plan_id]) 
  @destinations = @plan.destinations
  
  render :index
end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def set_destination
    @destination = @plan.destinations.find(params[:id])
  end

  def destination_params
    params.require(:destination).permit(:name, :description, :image)
  end
end