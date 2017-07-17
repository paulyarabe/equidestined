class FollowsController < ApplicationController

  def create
    @user = User.find(params[:following_id])
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def destroy
    @user = Follow.find(params[:id]).following
    current_user.unfollow(@user)
    redirect_to user_path(@user)
  end
end
