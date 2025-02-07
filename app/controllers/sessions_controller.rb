class SessionsController < ApplicationController
    def omniauth
      user = User.from_omniauth(request.env['omniauth.auth'])
  
      if user
        session[:user_id] = user.id
        redirect_to root_path, notice: "Signed in successfully!"
      else
        redirect_to root_path, alert: "Authentication failed."
      end
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "Signed out successfully!"
    end
  end