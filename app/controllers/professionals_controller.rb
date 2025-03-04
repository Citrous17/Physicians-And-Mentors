class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update]

  def index
    @professionals = User.where(isProfessional: true)
  end

  def show
    @professional = User.find(params[:id])
  end

  def new
    @professional = User.new
  end

  def edit; end

  def create
    @professional = User.new(professional_params)
    @professional.isProfessional = true  # Ensure they are marked as professionals

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Professional was successfully created." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @professional = User.find(params[:id])
    if @professional.update(professional_params)
      respond_to do |format|
        format.html { redirect_to professionals_path, notice: "Professional was successfully updated." }
        format.json { render :show, status: :ok, location: @professional }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_professional
    @professional = User.find(params[:id])
  end

  def professional_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :DOB, :phone_number, :profile_image_url, :isProfessional)
  end
end
