class SearchesController < ApplicationController

  def new
    @search = Search.new
    @search.user_id = current_user.id if logged_in?
    3.times {@search.locations << Location.new}
  end

  def create
    @search = Search.new
    @search.user_id = current_user.id if logged_in?
    params[:search][:location].each do |location|
      if !(location[:address] == "")
        @search.locations << Location.find_or_create_by(address: location[:address])
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

  def index
    # TODO could make this the action/route for both "all" and friends' searches and have a nav link or dropdown to choose between the two options (would need code change here to determine how @searches is set as well)
    @searches = Search.all
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
