class UserSearchesController < ApplicationController

  def show
    # NOTE action for clicking on a single search in user-specific search list
    @search = Search.find(params[:id])
    # NOTE will more than likely replace the line below with venues saved to search -- want to set the necessary params to display through results view like a new search would
    @venues = Venue.find_near(@search.midpoint)
    render 'results.html.erb'
  end

  def index
    # NOTE this will be a list of all searches for a specific user
    # can be used to see all your own searches OR all of another user's searches
  end

end
