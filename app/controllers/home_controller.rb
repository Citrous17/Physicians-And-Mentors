class HomeController < ApplicationController
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

end
