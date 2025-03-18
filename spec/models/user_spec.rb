require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        password: "password",
        DOB: "1990-01-01",
        phone_number: "1234567890",
        isProfessional: false
      )
      expect(user).to be_valid
    end

    it "is invalid without a first name" do
      user = User.new(first_name: nil)
      expect(user).not_to be_valid
    end

    it "is invalid without an email" do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      User.create!(
        first_name: "Jane",
        last_name: "Doe",
        email: "jane.doe@example.com",
        password: "password"
      )
      user = User.new(email: "jane.doe@example.com")
      expect(user).not_to be_valid
    end
  end
end