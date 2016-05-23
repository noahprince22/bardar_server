class BarsController < ApplicationController
  def new

  end

  def create

  end

  def edit

  end

  def show
    render json: Bar.find(params[:id])
  end

  def update

  end

  def destroy

  end

  def index
    render json: Bar.all
  end

  def near_me
    render json: Bar.near([params[:latitude], params[:longitude]], params[:radius])
  end
end
