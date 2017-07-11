class LocationsController < ApplicationController

  def new
    @location = Location.new
  end

  def create
    @location = Location.create(location_params)
    redirect_to location_path(@location)
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    redirect_to location_path(@location)
  end

  def show
    @location = Location.find(params[:id])
  end

  def index
    @locations = Location.all
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
  end

  private

  def location_params
    params.require(:location).permit(:address, :name, :latitude, :longitude)
  end

end
