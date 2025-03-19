require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) } # we use our factorybot defined in factories/user.rb to create a user object for testing!

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a first name" do
      subject.first_name = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a last name" do
      subject.last_name = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "email@provider.com")
      duplicate_user = subject.dup
      expect(duplicate_user).not_to be_valid
    end

    it "is invalid without a password" do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a DOB" do
      subject.DOB = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a phone number" do
      subject.phone_number = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a professional status" do
      subject.isProfessional = nil
      expect(subject).not_to be_valid
    end
  end

  describe ".from_omniauth" do
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

    context "when the user does not exist" do
      it "creates a new user" do
        result = User.from_omniauth(auth)
        user = result[:user]

        expect(user).to be_persisted
        expect(user.email).to eq('test@example.com')
        expect(user.first_name).to eq('Test')
        expect(user.last_name).to eq('User')
        expect(user.oauth_uid).to eq('123456789')
        expect(user.provider).to eq('google_oauth2')
        expect(result[:new_user]).to be true
      end
    end

    context "when the user exists with the same email" do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it "updates the existing user with OAuth details" do
        result = User.from_omniauth(auth)
        user = result[:user]

        expect(user).to eq(existing_user)
        expect(user.oauth_uid).to eq('123456789')
        expect(user.provider).to eq('google_oauth2')
        expect(user.profile_image_url).to eq('http://example.com/image.jpg')
        expect(result[:new_user]).to be false
      end
    end

    context "when the user exists with the same OAuth UID" do
      let!(:existing_user) { create(:user, oauth_uid: '123456789', provider: 'google_oauth2') }

      it "returns the existing user without creating a new one" do
        result = User.from_omniauth(auth)
        user = result[:user]

        expect(user).to eq(existing_user)
        expect(result[:new_user]).to be false
      end
    end
  end
end
