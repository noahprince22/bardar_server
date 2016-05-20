class MainController < ApplicationController
  def index
    @cities = ["Effingham", "Champaign"]
    params[:city] ||= "Champaign"
    @bars = Bar.near(params[:city], 20)
  end
end