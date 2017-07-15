class SearchesController < ApplicationController

  # TODO possibly add join table for venues returned by a search so those can be saved along with the search (just saving midpoint atm)?
  # would this saving happen in here or in model?

  def new
    @search = Search.new
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
    3.times {@search.locations << Location.new}
  end

  def create
    # TODO add validation so the same search isn't saved to the
    # db more than once for the same user? then put create in an if statement
    @search = Search.new
    if @search.locations.length == 1
      return new_search_path
    else
      params[:search][:location].each do |location|
        if !(location[:address] == "")
          @search.locations << Location.find_or_create_by(address: location[:address])
        end
      end
    end
    @search.midpoint = Midpoint.calculate(@search.locations)
    @search.save
    redirect_to search_path(@search)
  end

  def show
    @search = Search.find(params[:id])
    @venues = Venue.find_near(@search.midpoint)
    render 'results.html.erb'
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
