class CandidatesController < ApplicationController

  def index
    @candidates = @plan.candidates
  end

  def new
    @candidate = @plan.candidates.build
  end
  def create
    @plan = Plan.find(params[:plan_id])
    @candidate = @plan.candidates.build(candidate_params) 
    if @candidate.save
      redirect_to plan_availabilities_path(@plan), notice: "候補日が作成されました。"
    else
      redirect_to plan_availabilities_path(@plan), alert: "候補日を選択してください。"
    end
  end

  def destroy
    @plan = Plan.find(params[:plan_id])
    @candidate = @plan.candidates.find(params[:id])
    @candidate.destroy
    redirect_to plan_availabilities_path(@plan), notice: "候補日が削除されました。"
  end

  private
  def candidate_params
    params.require(:candidate).permit(:date)
  end
  
end