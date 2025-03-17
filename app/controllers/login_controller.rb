class LoginController < ApplicationController
    def new
    end

    def omniauth
        user = User.from_omniauth(request.env['omniauth.auth'])
    
        if user
          session[:user_id] = user.id
          session[:email] = user.email
          session[:first_name] = user.first_name
          session[:last_name] = user.last_name
          session[:isProfessional] = user.isProfessional
          session[:isAdmin] = user.isAdmin
          redirect_to root_path, notice: "Signed in successfully!"
        else
          redirect_to root_path, alert: "Authentication failed."
        end
      end

    
  end