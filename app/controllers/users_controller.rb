class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy ] # Add :destroy here
  before_action :require_login, only: [ :complete_profile, :update_complete_profile ]

  def index
    @users = User.all
    session[:filter] = params[:filter] if params[:filter].present?
    session[:filter_option] = params[:filter_option] if params[:filter_option].present?
    initialize_search
    handle_search_name
    handle_filters
  end

  def newAuth # for a user created via google authentication
    @user = current_user || User.new(isProfessional: false) # by default, set to false

    if request.post? && @user.invalid?
      render :newAuth
    end
  end

  def complete_profile # you must be "logged in" to complete a profile
    @user = current_user

    unless @user
      redirect_to login_path, alert: "You must be logging in to complete your profile."
      nil
    end
  end

  def update_complete_profile
    # This is the method that will handle the form submission for profile completion
    @user = current_user

    if @user.update(user_params)  # Check if the profile gets updated
      redirect_to root_path, notice: "Profile completed successfully!"
    else
      # If validation fails, render the `complete_profile` form again with errors
      render :complete_profile
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def invalid_image_url?(url)
    return true if url.blank?
  
    begin
      # Only allow certain image types (png, jpg, jpeg, gif)
      uri = URI.parse(url)
      return true unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  
      content_type = URI.open(uri, allow_redirections: :all).content_type
      !content_type.start_with?('image/')
    rescue
      true
    end
  end

  def create
    @user = User.new(user_params)

    if invalid_image_url?(@user.profile_image_url)
      @user.profile_image_url = helpers.asset_path("profile-placeholder.png")
    end

    respond_to do |format|
      if @user.save
        # Check if the user is from OAuth
        if @user.oauth_uid.present?
          # Redirect OAuth users to the profile completion form
          format.html { redirect_to new_auth_path, notice: "Welcome! Please complete your profile." }
        else
          # For regular users, redirect to the user index page
          format.html { redirect_to users_path, notice: "User was successfully created." }
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_destroy
    @user = User.find(params[:id])
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  def clear
    clear_session(:search_name, :filter_name, :filter)
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through. user_params moved to application_controller because it's so frequently used
    def user_params
      params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation, :DOB, :phone_number, :profile_image_url, :isProfessional, :isAdmin)
    end

    def oauth_params
      params.require(:user).permit(:last_name, :first_name, :password, :password_confirmation, :DOB, :phone_number)
    end

    def initialize_search
      # Check if there's a new search term
      if params[:search_name].present?
        session[:search_name] = params[:search_name]
        session[:filter] = nil
        session[:filter_option] = nil
      else
        session[:search_name] = nil
        session[:filter] = nil
        session[:filter_option] = nil
        # If no new search term, use the previous session values (if they exist)
        # session[:search_name] ||= params[:search_name]
        # session[:filter] = params[:filter]
        # params[:filter_option] = nil if params[:filter_option] == ""
        # session[:filter_option] = params[:filter_option]
      end
      if params[:filter].present?
        session[:filter] = params[:filter]
      end

      if params[:filter_option].present?
        session[:filter_option] = params[:filter_option]
      end
    end

    def handle_search_name
      if session[:search_name]
        @users = User.where("first_name LIKE ?", "%#{session[:search_name].titleize}%")
      else
        @users = User.all
      end
    end

    def handle_filters
      if session[:filter_option] && session[:filter] == "isProfessional"
        is_professional_value = session[:filter_option] == "True"
        @users = @users.where(isProfessional: is_professional_value)
      end
      if session[:filter_option] && session[:filter] == "isSpecialty"
        if session[:filter_option] == "all"
          is_professional_value = session[:isProfessional] == "True"
          @users = @users.where(isProfessional: is_professional_value == false)
        else
          # is_professional_value = session[:filter_option] == "True"
          # user_specialty_ids = current_user.specialties.pluck(:id)
          is_professional_value = session[:isProfessional] == "True"
          @users = @users.joins(:specialties).where(isProfessional: is_professional_value == false).where(specialties: { id: session[:filter_option] })
        end
      end
    end
  end
