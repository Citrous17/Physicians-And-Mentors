class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]

  def index
    @professionals = User.where(isProfessional: true)
    session[:filter] = params[:filter] if params[:filter].present?
    session[:filter_option] = params[:filter_option] if params[:filter_option].present?
    initialize_search
    handle_search_name
    handle_filters
  end

  def show; end  # No need to find @professional again

  def new
    @professional = User.new
  end

  def edit
    @professional = User.find(params[:id])
  end

  def create
    @professional = User.new(professional_params)
    @professional.isProfessional = true

    if params[:user][:specialty_ids].present?
      @professional.specialty_ids = params[:user][:specialty_ids]
    end

    respond_to do |format|
      if @professional.save
        format.html { redirect_to professionals_path, notice: "Professional was successfully created." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @professional = User.find(params[:id])
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to professionals_path, notice: "Professional was successfully updated." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @professional.destroy

    respond_to do |format|
      format.html { redirect_to professionals_path, status: :see_other, notice: "Professional was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def confirm_destroy
    @professional = User.find(params[:id])
  end

  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  def clear
    clear_session(:search_name, :filter_name, :filter)
    redirect_to professionals_path
  end

  private

  def set_professional
    @professional = User.find(params[:id])
  end

  def professional_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation, :DOB, :phone_number, :profile_image_url, :isProfessional, specialty_ids: [])
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
      @professionals = User.where("first_name LIKE ?", "%#{session[:search_name].titleize}%")
    else
      @professionals = User.all
    end
  end

  def handle_filters
    if session[:filter_option] && session[:filter] == "isProfessional"
      is_professional_value = session[:filter_option] == "True"
      @professionals = @professionals.where(isProfessional: is_professional_value)
    end
    if session[:filter_option] && session[:filter] == "isSpecialty"
      if session[:filter_option] == "all"
        is_professional_value = session[:isProfessional] == "True"
        @professionals = @professionals.where(isProfessional: is_professional_value == false)
      else
        # is_professional_value = session[:filter_option] == "True"
        # user_specialty_ids = current_user.specialties.pluck(:id)
        is_professional_value = session[:isProfessional] == "True"
        @professionals = @professionals.joins(:specialties).where(isProfessional: is_professional_value == false).where(specialties: { id: session[:filter_option] })
      end
    end
  end
end
