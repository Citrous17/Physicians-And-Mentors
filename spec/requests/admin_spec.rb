require 'rails_helper'

RSpec.describe "Admins", type: :request do
  # SIMULATE an admin user for the tests
  let!(:admin_user) {create(:user, isAdmin:true)}

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
  end

  describe "GET /dashboard" do
    it "returns http success" do
      get "/admin/dashboard"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users" do
    it "returns http success" do
      get "/admin/users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /database" do
    it "returns http success" do
      get "/admin/database"
      expect(response).to have_http_status(:success)
    end
  end
end
