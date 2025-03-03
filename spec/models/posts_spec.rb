require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with a title, content, and user" do
      user = User.create!(name: "Test User", email: "test@example.com", password: "password")
      post = Post.new(title: "Test Post", content: "This is a test.", sending_user_id: user.id)

      expect(post).to be_valid
    end

    it "is invalid without a title" do
      post = Post.new(content: "This is a test.")
      expect(post).not_to be_valid
    end

    it "is invalid without content" do
      post = Post.new(title: "Test Post")
      expect(post).not_to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:sending_user).class_name('User') }
    it { should have_and_belong_to_many(:specialties) }
  end
end
