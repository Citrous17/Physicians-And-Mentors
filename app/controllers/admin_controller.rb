class AdminController < ApplicationController
    before_action :authenticate_admin

    def dashboard
      @invite_codes = InviteCode.all.order(created_at: :desc)
    end

    def users
      @users = User.all
    end

    def database
      @tables = ActiveRecord::Base.connection.tables
    end

    def index
      @invite_codes = InviteCode.all.order(created_at: :desc)
    end
  
    def create_invite_code
      email = params[:email]
      invite_code = InviteCode.create!(user_email: email, expires_at: 7.days.from_now, used: false)
    
      flash[:notice] = "Invite code #{invite_code.code} created for #{email}!"
      redirect_to admin_dashboard_path
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
