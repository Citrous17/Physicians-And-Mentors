class ProfessionalsController < ApplicationController
  def index
    @professionals = User.where(isProfessional: true)
  end

  def show
    @professional = User.find(params[:id])
  end

  def new
    @professional = User.new
  end

  def edit
    @professional = User.find(params[:id])
  end

  def create
    @professional = User.new(professional_params)
    @professional.isProfessional = true

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

  private

    def professional_params
      params.require(:user).permit(:last_name, :first_name, :email, :password_digest, :DOB, :phone_number, :profile_image_url)
    end
end