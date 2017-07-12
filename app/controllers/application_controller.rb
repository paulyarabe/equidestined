class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "index"

  helper_method :current_user, :logged_in?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(sessions[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    if !logged_in?
      redirect_to login_path
    end
  end


end
