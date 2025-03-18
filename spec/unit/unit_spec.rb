require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      first_name: 'firstname',
      last_name: 'lastname',
      email: 'email@provider.com',
      password: 'mypassword',
      password_confirmation: 'mypassword',
      DOB: Date.new(2025,1,1),
      phone_number: '999999999',
      profile_image_url: 'profile.image.link',
      isProfessional: false
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a first name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a last name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid with an email' do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a password digest' do
    subject.password = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a dob' do
    subject.DOB = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a phone number' do
    subject.phone_number = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a professional status' do
    subject.isProfessional = nil
    expect(subject).not_to be_valid
  end

end