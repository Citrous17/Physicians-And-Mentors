class SessionsController < ApplicationController
    def omniauth
      user = User.from_omniauth(request.env['omniauth.auth'])
      
      if user
        session[:user_id] = user.id
        session[:email] = user.email
        session[:first_name] = user.first_name
        session[:last_name] = user.last_name
        session[:isProfessional] = user.isProfessional
        redirect_to root_path, notice: "Signed in successfully!"
      else
        redirect_to root_path, alert: "Authentication failed."
      end
    end

    def create
      user = User.find_by(email: params[:email])

      if (user[:password_digest] == params[:password])
        session[:user_id] = user.id
        session[:email] = user.email
        session[:first_name] = user.first_name
        session[:last_name] = user.last_name
        session[:isProfessional] = user.isProfessional

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
      
      redirect_to root_path, notice: "Signed out successfully!"
    end
  end