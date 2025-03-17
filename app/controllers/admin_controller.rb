class AdminController < ApplicationController
    before_action :authenticate_admin

    def dashboard
      # Dashboard logic
    end

    def users
      @users = User.all
    end

    def database
      @tables = ActiveRecord::Base.connection.tables
    end

    def invite_admin
      user = User.find_by(email: params[:email])
      if user
        user.update(isAdmin: true)
        flash[:notice] = "#{user.email} is now an admin!"
      else
        flash[:alert] = "User not found."
      end
      redirect_to admin_dashboard_path
    end

    private

    def authenticate_admin
      redirect_to root_path, alert: "Access denied." unless current_user&.isAdmin?
    end
  end
