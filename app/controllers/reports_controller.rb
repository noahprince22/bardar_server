class ReportsController < ApplicationController
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to @report
    else
      render 'new'
    end
  end

  def show
    render json: Report.find(params[:id])
  end

  private
  def report_params
    params.require(:report).permit(
        :line_length,
        :cover_charge,
        :ratio,
        :avg_age,
        :crowd,
        :user_id,
        :bar_id)
  end
end