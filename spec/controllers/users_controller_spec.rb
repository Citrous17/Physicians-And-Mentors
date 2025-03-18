require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user" do
        expect {
          post :create, params: { user: { first_name: "John", last_name: "Doe", email: "john.doe@example.com", password: "password" } }
        }.to change(User, :count).by(1)
      end

      it "redirects to the users index" do
        post :create, params: { user: { first_name: "John", last_name: "Doe", email: "john.doe@example.com", password: "password" } }
        expect(response).to redirect_to(users_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a new user" do
        expect {
          post :create, params: { user: { first_name: nil } }
        }.not_to change(User, :count)
      end

      it "re-renders the new template" do
        post :create, params: { user: { first_name: nil } }
        expect(response).to render_template(:new)
      end
    end
  end
end