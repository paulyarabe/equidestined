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
    @search.venues = Venue.find_near(@search)
    @search.user_id = current_user.id if logged_in?

    if @search.save
      redirect_to search_path(@search)
    else
      redirect_to new_search_path(@search)
    end
  end

  def show
    @search = Search.find(params[:id])
    render 'results.html.erb'
  end

  def index
    @title = "See what others are searching for!"
    @searches = Search.all
  end

  def friends
    # TODO make this not crash if a user has no friends
    @title = "See what your friends are searching for!"
    @searches = Search.where({ user_id: current_user.following.select(:id) }).order(created_at: :desc)
    render 'index.html.erb'
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
