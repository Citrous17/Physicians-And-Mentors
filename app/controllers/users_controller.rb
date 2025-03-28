class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all 
    session[:filter] = params[:filter] if params[:filter].present?
    session[:filter_option] = params[:filter_option] if params[:filter_option].present?
    initialize_search
    handle_search_name
    handle_filters
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: "User was successfully created." }
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

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:last_name, :first_name, :email, :password, :DOB, :phone_number, :profile_image_url, :isProfessional)
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
    end   


end
