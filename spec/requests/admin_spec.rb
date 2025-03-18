require 'rails_helper'

RSpec.describe "Admins", type: :request do
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
