require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with a title, content, and sending_user_id" do
      user = User.create!(
        first_name: "Test",
        last_name: "User",
        email: "test@example.com",
        password: "password"
      )
      post = Post.new(
        title: "Test Post",
        content: "This is a test post.",
        sending_user_id: user.id
      )
      expect(post).to be_valid
    end

    it "is invalid without a title" do
      post = Post.new(title: nil)
      expect(post).not_to be_valid
    end

    it "is invalid without content" do
      post = Post.new(content: nil)
      expect(post).not_to be_valid
    end
  end
end
