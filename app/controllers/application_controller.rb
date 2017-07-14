class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?


  def logged_in?
    !!current_user
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def authorized
    if !logged_in?
      redirect_to login_path
    end
  end


end
