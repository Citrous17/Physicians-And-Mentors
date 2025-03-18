class SessionsController < ApplicationController
  def omniauth
    auth = request.env['omniauth.auth']
    result = User.from_omniauth(auth)
    user = result[:user]
    new_user = result[:new_user]
  
    if user
      session[:user_id] = user.id
  
      if new_user
        redirect_to new_auth_path, notice: "Welcome! Please complete your profile."
      else
        redirect_to root_path, notice: "Signed in successfully!"
      end
    else
      redirect_to root_path, alert: "Authentication failed."
    end
  end
  

    def create
      user = User.find_by(email: params[:email])

      if user && user.authenticate(params[:password])
        if user.has_password?
          session[:user_id] = user.id
          redirect_to root_path, notice: "Signed in successfully!"
        else
          redirect_to password_reset_path, alert: "Your account was created with OAuth. Please reset your password to log in."
        end
      else
        redirect_to login_path, alert: "Invalid email or password."
      end      
    end    
  
    def destroy
      session[:user_id] = nil
      session[:email] = nil
      session[:first_name] = nil
      session[:last_name] = nil
      session[:isProfessional] = nil
      
      redirect_to root_path, notice: "Signed out successfully!"
    end
  end