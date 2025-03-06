require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = User.create!(
      first_name: 'firstname',
      last_name: 'lastname',
      email: 'email@provider.com',
      password: 'mypassword',
      password_confirmation: 'mypassword',
      DOB: Date.new(2025,1,1),
      phone_number: '999999999',
      profile_image_url: 'profile.image.link',
      isProfessional: false
    )
  end

  describe "GET /users" do
    it "returns http success" do
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_user_path(@user)
      expect(response).to have_http_status(:success)
    end
  end

end
