class SpecialtiesController < ApplicationController
    before_action :require_login
    before_action :require_admin
    before_action :set_specialty, only: [:edit, :show, :update, :destroy]

    def index
        @specialties = Specialty.all
    end

    def new
        @specialty = Specialty.new
    end

    def edit; end

    def show; end

    def create
        @specialty = Specialty.new(specialty_params)
        if @specialty.save
            redirect_to specialties_path, notice: "Specialty was successfully created."
          else
            render :new, status: :unprocessable_entity
          end
    end

    def update
        respond_to do |format|
            if @specialty.update(specialty_params)
                format.html { redirect_to specialties_path, notice: "Specialty was successfully updated." }
                format.json { render :show, status: :ok, location: @specialty }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @specialty.errors, status: :unprocessable_entity }
            end
        end
    end
    
    def destroy
        @specialty.destroy

        respond_to do |format|
            format.html { redirect_to specialties_path, notice: "Specialty was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    private
        def specialty_params
            params.require(:name)
        end

        def set_specialty
            @specialty = Specialty.find(params[:id])
        end

end