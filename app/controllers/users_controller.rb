class UsersController < ApplicationController
  def index
    @users = User.all 
  end

  def new
    @user = User.new
  end

  def edit
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
    def set_book
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:last_name, :first_name, :email, :password, :dob, :phone_number, :profile_image_url, :is_professional)
    end


end
