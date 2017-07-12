class LocationsController < ApplicationController


  # basically, the home (consisting of the search boxes); 2.times becasue MVP
  def index
    @current_user = User.find_by(params[:email])
    @locations = []
    2.times do
      @locations << Location.new
    end
  end

  # params[:locations] holds an array of the two addresses
  # here, we want to create each location, set it to @locations_array
  # then, pass that to Midpoint.calculate
  def create
    @locations_array = params[:locations].collect do |location|
      Location.create(location_params(location))
    end
    @midpoint = Midpoint.calculate(@locations_array)
    redirect_to results_path
  end
  # here, we basically get taken to results.html.erb, call Midpoint.last.blah
  # to get the last search's midpoint
  def results
  end

  private
  def location_params(my_params)
    my_params.permit(:address)
  end
end
