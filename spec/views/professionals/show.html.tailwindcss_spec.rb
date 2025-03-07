require 'rails_helper'

RSpec.describe "professionals/show", type: :view do
  before(:each) do
    assign(:professional, User.create!(
      last_name: "Last Name",
      first_name: "First Name",
      email: "Email",
      password: "Password Digest",
      phone_number: "Phone Number",
      profile_image_url: "Profile Image Url",
      isProfessional: true,
      DOB: Date.new(1990, 5, 15)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone Number/)
    expect(rendered).to match(/Profile Image Url/)
    expect(rendered).to match(/true/)
  end
end
