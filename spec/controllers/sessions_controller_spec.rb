require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "renders the login page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let!(:user) { User.create!(email: "test@example.com", password: "password") }

    context "with valid credentials" do
      it "logs in the user" do
        post :create, params: { email: "test@example.com", password: "password" }
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the root path" do
        post :create, params: { email: "test@example.com", password: "password" }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      it "does not log in the user" do
        post :create, params: { email: "test@example.com", password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
      end

      it "re-renders the login page" do
        post :create, params: { email: "test@example.com", password: "wrongpassword" }
        expect(response).to render_template(:new)
      end
    end
  end
end