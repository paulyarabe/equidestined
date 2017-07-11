class SearchesController < ApplicationController
  helper_method :save

  # NOTE
  # search = Search.new
  # search.locations = [loc1, loc2] -- or shovel one at a time
  # Midpoint.calculate(search.locations) -- gets midpoint and stores
  # need logic to store the locations? to allow search to be saved?
  # default user_id to 1 until authentication piece is complete
  # TODO figure out how to denote search.locations in form_for?

  def new
    @search = Search.new
    @location = Location.new
    #@search.locations = [Location.new, Location.new]
  end

  def create
    # TODO add validation so the same search isn't saved to the
    # db more than once? then put create in an if statement
    @search = Search.create(search_params)
    # hardcoding user_id to 1 at this time
    @search.user_id = 1
    @search.save
    redirect_to search_path(@search)
  end

  def edit
    @search = Search.find(params[:id])
  end

  def update
    # NOTE will this be used? if so, need to add vaidation
    # and enclose in an if statement
    @search = Search.find(params[:id])
    @search.update(search_params)
    redirect_to search_path(@search)
  end

  def show
    @search = Search.find(params[:id])
  end

  def index
    @searches = Search.all
  end

  def destroy
    @search = Search.find(params[:id])
    @search.destroy
  end

  private

  def search_params
    params.require(:search).permit(:address, :name, :latitude, :longitude)
  end

end
