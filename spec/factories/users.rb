# filepath: spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    email { "john.doe@example.com" }
    password { "password" }
    password_confirmation { "password" }
    DOB { "1990-01-01" }
    phone_number { "1234567890" }
    profile_image_url { "http://example.com/image.jpg" }
    isProfessional { true }
    isAdmin { false }
    oauth_uid { nil }
    provider { nil }
  end
end