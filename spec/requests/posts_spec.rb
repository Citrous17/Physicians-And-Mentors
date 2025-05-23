require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", DOB: "2000-01-01", phone_number: "1234567890", isProfessional: false) }
  let(:specialty) { Specialty.create!(name: "Cardiology") }
  let(:valid_attributes) { { title: "Test Post", content: "This is a test post.", sending_user_id: user.id, specialty_ids: [ specialty.id ] } }
  let(:invalid_attributes) { { title: "", content: "" } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /index" do
    it "returns a successful response" do
      get posts_path
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "displays a specific post" do
      post = Post.create!(valid_attributes)
      get post_path(post)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
      it "creates a new post" do
        expect {
          post posts_path, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)

        expect(response).to redirect_to(posts_path)
        follow_redirect!
        expect(response.body).to include("Test Post")
      end
    end

    context "with invalid attributes" do
      it "does not create a post" do
        expect {
          post posts_path, params: { post: invalid_attributes }
        }.not_to change(Post, :count)

        expect(response.body).to match(/Title can&#39;t be blank/)
        expect(response.body).to match(/Content can&#39;t be blank/)
      end
    end
  end
end
