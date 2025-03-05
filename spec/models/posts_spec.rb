require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with a title, content, user, and time" do
        user = User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", DOB: "2000-01-01", phone_number: "1234567890", isProfessional: false)
        post = Post.new(title: "Test Post", content: "This is a test.", sending_user_id: user.id)
        expect(post).to be_valid
    end
    
    it "is invalid without a user" do
        post = Post.new(title: "testing title", content: "testing content")
        expect(post).not_to be_valid
    end

    it "is invalid without a title" do
      user = User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", DOB: "2000-01-01", phone_number: "1234567890", isProfessional: false)
      post = Post.new(content: "This is a test.", sending_user_id: user.id)
      expect(post).not_to be_valid
    end

    it "is invalid without content" do
      user = User.create!(first_name: "Test", last_name: "User", email: "test@example.com", password: "password", DOB: "2000-01-01", phone_number: "1234567890", isProfessional: false)
      post = Post.new(title: "Test Post", sending_user_id: user.id)
      expect(post).not_to be_valid
    end
  end
end
