require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "renders the login page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let!(:user) { create(:user, email: "test@example.com", password: "password") }

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

  describe "GET #omniauth" do
        let(:auth) do
            OmniAuth::AuthHash.new(
            provider: 'google_oauth2',
            uid: '123456789',
            info: {
                email: 'test@example.com',
                first_name: 'Test',
                last_name: 'User',
                image: 'http://example.com/image.jpg'
            }
            )
        end

        before do
            request.env['omniauth.auth'] = auth
        end

        context "when the user is new" do
            it "creates a new user and redirects to the new_auth path" do
            expect {
                get :omniauth
            }.to change(User, :count).by(1)

            expect(response).to redirect_to(new_auth_path)
            expect(flash[:notice]).to eq('Welcome! Please complete your profile.')
            end
        end

        context "when the user already exists with the same email" do
            let!(:existing_user) { create(:user, email: 'test@example.com') }

            it "logs in the existing user and redirects to the root path" do
            get :omniauth

            expect(session[:user_id]).to eq(existing_user.id)
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq('Signed in successfully!')
            end
        end

        context "when the user already exists with the same OAuth UID" do
            let!(:existing_user) { create(:user, oauth_uid: '123456789', provider: 'google_oauth2') }

            it "logs in the existing user and redirects to the root path" do
            get :omniauth

            expect(session[:user_id]).to eq(existing_user.id)
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq('Signed in successfully!')
            end
        end

        context "when authentication fails" do
            before do
            allow(User).to receive(:from_omniauth).and_return(nil)
            end

            it "redirects to the root path with an alert" do
            get :omniauth

            expect(response).to redirect_to(root_path)
            expect(flash[:alert]).to eq('Authentication failed.')
            end
        end
        end
    end
end