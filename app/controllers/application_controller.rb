class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  def require_login
    unless current_user
      flash[:alert] = "You must be logged in to perform this action!"
      redirect_to login_path
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "You do not have permission to view this page!"
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
end
