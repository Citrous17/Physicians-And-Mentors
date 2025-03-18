class SessionsController < ApplicationController

        
  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    result = User.from_omniauth(auth)
    user = result[:user]
    new_user = result[:new_user]
  
    if user
      session[:user_id] = user.id
      session[:user_id] = user.id
      session[:email] = user.email
      session[:first_name] = user.first_name
      session[:last_name] = user.last_name
      session[:isProfessional] = user.isProfessional
      session[:isAdmin] = user.isAdmin
      redirect_to root_path, notice: "Signed in successfully!"
    end
    if new_user
      redirect_to new_auth_path, notice: "Welcome! Please complete your profile."
    else
      redirect_to root_path, alert: "Authentication failed."
    end
  end
  

    def create
      user = User.find_by(email: params[:email])

      if user && (user[:password_digest] == params[:password])
        session[:user_id] = user.id
        session[:email] = user.email
        session[:first_name] = user.first_name
        session[:last_name] = user.last_name
        session[:isProfessional] = user.isProfessional
        session[:isAdmin] = user.isAdmin
        redirect_to root_path, notice: "Signed in successfully!"
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
      session[:isAdmin] = nil
      redirect_to root_path, notice: "Signed out successfully!"
    end
  end