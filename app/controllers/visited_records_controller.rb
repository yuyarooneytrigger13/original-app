class VisitedRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @visited_records = current_user.visited_records

    case params[:sort]
    when 'date_asc'
      @visited_records = @visited_records.order(visited_date: :asc)
    when 'prefecture'
      @visited_records = @visited_records.order(prefecture: :asc)
    else
      @visited_records = @visited_records.order(visited_date: :desc)
    end

    respond_to do |format|
      format.html # index.html.erb を表示
      format.json { 
        render json: @visited_records.map { |record| {
          prefecture: record.prefecture,
          visited_date: record.visited_date,
          review: record.review
        }}
      }
    end
  end
  def create
    @record = current_user.visited_records.find_or_initialize_by(prefecture: params[:visited_record][:prefecture])
    if @record.update(visited_record_params)
      render json: { status: 'success' }
    else
      render json: { status: 'error', errors: @record.errors }, status: :unprocessable_entity
    end
  end

  def edit
    @visited_record = current_user.visited_records.find(params[:id])
  end

  def update
    @visited_record = current_user.visited_records.find(params[:id])
    if @visited_record.update(visited_record_params)
      redirect_to visited_records_path, notice: "訪問記録を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    # 一覧画面からはID、地図からは都道府県IDが送られてくる可能性があるため両方考慮
    @record = current_user.visited_records.find_by(id: params[:id]) || current_user.visited_records.find_by(prefecture: params[:id])

    if @record&.destroy
      respond_to do |format|
        format.html { redirect_to visited_records_path, notice: "訪問記録を削除しました。" }
        format.json { render json: { status: 'success' } }
      end
    else
      respond_to do |format|
        format.html { redirect_to visited_records_path, alert: "削除できませんでした。" }
        format.json { render json: { status: 'error' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def visited_record_params
    params.require(:visited_record).permit(:prefecture, :visited_date, :review, :image)
  end
end
