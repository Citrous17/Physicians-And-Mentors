class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[show edit update destroy]

  def index
    @professionals = User.where(isProfessional: true)
  end

  def show; end  # No need to find @professional again

  def new
    @professional = User.new
  end

  def edit; end

  def create
    @professional = User.new(professional_params)
    @professional.isProfessional = true  # Ensure they are marked as professionals

    if @professional.save
      redirect_to professionals_path, notice: "Professional was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @professional.update(professional_params)
      redirect_to @professional, notice: 'Professional was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @professional.destroy
    redirect_to professionals_url, notice: "Professional was successfully deleted."
  end

  private

  def set_professional
    @professional = User.find(params[:id])
  end

  def professional_params
    allowed_params = [:first_name, :last_name, :email, :DOB, :phone_number]
    allowed_params += [:password, :password_confirmation] if params[:user][:password].present?
    params.require(:user).permit(allowed_params)
  end
end
