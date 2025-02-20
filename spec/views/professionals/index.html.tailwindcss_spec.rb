require 'rails_helper'

RSpec.describe "professionals/index", type: :view do
  before(:each) do
    assign(:professionals, [
      Professional.create!(
        last_name: "Last Name",
        first_name: "First Name",
        email: "Email",
        password_digest: "Password Digest",
        phone_number: "Phone Number",
        profile_image_url: "Profile Image Url",
        isProfessional: false
      ),
      Professional.create!(
        last_name: "Last Name",
        first_name: "First Name",
        email: "Email",
        password_digest: "Password Digest",
        phone_number: "Phone Number",
        profile_image_url: "Profile Image Url",
        isProfessional: false
      )
    ])
  end

  it "renders a list of professionals" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Password Digest".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Profile Image Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
