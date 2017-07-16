class SearchesController < ApplicationController

  def new
    @search = Search.new
    @search.user_id = current_user.id if logged_in?
    3.times {@search.locations << Location.new}
  end

  def create
    @search = Search.new
    # TODO potentially add in ability to display error in @search.errors[:locations][1]
    params[:search][:location].each {|location| @search.locations << Location.find_or_create_by(address: location[:address]) unless location[:address].empty?}
    @search.midpoint = Midpoint.calculate(@search.locations)
    @search.user_id = current_user.id if logged_in?

    if @search.save
      redirect_to search_path(@search)
    else
      redirect_to new_search_path(@search)
    end
  end

  def show
    @search = Search.find(params[:id])
    @venues = Venue.find_near(@search.midpoint)
    render 'results.html.erb'
  end

  def index
    # TODO could make this the action/route for both "all" and friends' searches -- and also probably the user's own searches? -- and have a nav link or dropdown to choose between the two options (would need code change here to determine how @searches is set as well)
    @searches = Search.all
  end

  def sample
    @searches = Search.all
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
