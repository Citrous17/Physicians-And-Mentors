class UsersController < ApplicationController
  def index
    @users = User.all 
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:last_name, :first_name, :email, :password_digest, :DOB, :phone_number, :profile_image_url, :isProfessional)
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
        @users = @users.where(isProfessional: session[:filter_option])
      end
    end   


end
