class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]

  def index
    @professionals = User.where(isProfessional: true)
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

  private

  def set_professional
    @professional = User.find(params[:id])
  end

  def professional_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation, :DOB, :phone_number, :profile_image_url, :isProfessional, specialty_ids: [])
  end
end
