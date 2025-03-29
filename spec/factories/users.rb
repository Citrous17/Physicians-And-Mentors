# filepath: spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "First Name" }
    last_name { "Last Name" }
    password { "password" }
    isProfessional { true }
    DOB { Date.parse("2024-07-07") }
  end
end