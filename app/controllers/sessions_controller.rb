class SessionsController < ApplicationController
  def new
    # Renders the login page
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password]) # Ensure `has_secure_password` is set up
      set_session(user)
      redirect_to root_path, notice: "Signed in successfully!"
    else
      redirect_to login_path, alert: "Invalid email or password."
    end
  end

  def signup
    @user = User.new
  end

  def register
    @user = User.new(user_params) # Use strong parameters

    if @user.save
      set_session(@user)
      redirect_to root_path, notice: "Signed up successfully!"
    else
      render :signup, status: :unprocessable_entity
    end
  end

  def omniauth
    result = User.from_omniauth(request.env["omniauth.auth"])
    user = result[:user]
    new_user = result[:new_user]

    if user
      set_session(user)
      if new_user
        redirect_to new_auth_path, notice: "Welcome! Please complete your profile."
      else
        redirect_to root_path, notice: "Signed in successfully!"
      end
    else
      redirect_to root_path, alert: "Authentication failed."
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out successfully!"
  end

  private

  def set_session(user)
    session[:user_id] = user.id
    session[:email] = user.email
    session[:first_name] = user.first_name
    session[:last_name] = user.last_name
    session[:isProfessional] = user.isProfessional
    session[:isAdmin] = user.isAdmin
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :isProfessional, :isAdmin)
  end
end
