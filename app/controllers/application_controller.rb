class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if logged_in?
  end

  def require_user
    block_client unless logged_in?
  end

  def block_client
    flash[:danger] = "Not Allowed"
    redirect_to root_path
  end

  def logged_in?
    !!session[:user_id]
  end
end
