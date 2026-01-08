class PlansController < ApplicationController

  def new
    @plan = Plan.new
  end


  def show
    @plan = Plan.find(params[:id])
  end

end
