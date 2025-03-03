require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "password") }
  let(:specialty) { Specialty.create!(name: "Cardiology") }
  let(:valid_attributes) { { title: "Test Post", content: "This is a test post.", sending_user_id: user.id, specialty_ids: [specialty.id] } }
  let(:invalid_attributes) { { title: "", content: "" } }

  before do
    sign_in user  # Assuming Devise authentication
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

        expect(response.body).to include("Title can't be blank")
      end
    end
  end
end