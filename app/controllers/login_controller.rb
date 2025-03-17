class LoginController < ApplicationController
    def new
    end

    def signup
      @user = User.new
    end

    def create
        @user = User.new(user_params) # Use strong parameters

        if @user.save
            session[:user_id] = @user.id
            session[:email] = @user.email
            session[:first_name] = @user.first_name
            session[:last_name] = @user.last_name
            redirect_to root_path, notice: "Signed up successfully!"
        else
            render :signup, status: :unprocessable_entity
        end
    end

    def email 
        user = User.find_by(email: params[:email])

        if user && (user[:password_digest] == params[:password])
            session[:user_id] = user.id
            redirect_to root_path, notice: "Signed in successfully!"
        else
            redirect_to login_path, alert: "Invalid email or password."
        end
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

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :isProfessional, :isAdmin)
    end
    
  end