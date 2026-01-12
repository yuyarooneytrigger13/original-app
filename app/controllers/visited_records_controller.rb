class VisitedRecordsController < ApplicationController
  def index
    records = current_user.visited_records
    render json: records.map { |record| {
      prefecture: record.prefecture,
      visited_date: record.visited_date,
      review: record.review
    }}
  end
  def create
    @record = current_user.visited_records.find_or_initialize_by(prefecture: params[:visited_record][:prefecture])
    if @record.update(visited_record_params)
      render json: { status: 'success' }
    else
      render json: { status: 'error', errors: @record.errors }, status: :unprocessable_entity
    end
  end
  def destroy
    @record = current_user.visited_records.find_by(prefecture: params[:id])
    if @record&.destroy
      render json: { status: 'success' }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  private

  def visited_record_params
    params.require(:visited_record).permit(:prefecture, :visited_date, :review)
  end
end