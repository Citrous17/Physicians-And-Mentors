require 'rails_helper'

RSpec.describe "User Signup", type: :system do
  it "allows a user to sign up" do
    visit signup_path

    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Email", with: "john.doe@example.com"
    fill_in "Password", with: "password"
    fill_in "Re-enter Password", with: "password"
    click_button "Submit"

    expect(page).to have_content("Signed up successfully!")
  end
end
