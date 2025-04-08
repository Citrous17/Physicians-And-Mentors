class HomeController < ApplicationController
  before_action :require_admin, only: [:help]
  def index
  end

  def new
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out successfully!"
  end

  def help
  end

  private

  def require_admin
    unless current_user&.isAdmin
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end