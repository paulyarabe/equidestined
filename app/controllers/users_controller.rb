class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_search_path
    else
      render :signup
    end
  end

  def show
    @user = User.find(params[:id])
    render 'profile.html.erb'
  end

  def store_venue
    @user = User.find_by_id(current_user)
    venue = Venue.find(params[:venue_id])
    @user.save_venue(venue)
    render 'profile.html.erb'
  end

  def index
    @title = "All Users"
    @users = User.all
    render 'index.html.erb'
  end

  def following
    @title = "My Friends"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'index.html.erb'
  end

  def searches
    @user = User.find(params[:id])
    @title = @user == current_user ? "My Searches" : "#{@user.name}'s Searches"
    @searches = @user.searches
    render '/searches/index.html.erb'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
