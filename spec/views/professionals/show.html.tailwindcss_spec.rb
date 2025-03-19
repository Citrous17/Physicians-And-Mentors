require 'rails_helper'

RSpec.describe "professionals/show", type: :view do
  before(:each) do
    assign(:professional, User.create!(
      last_name: "Last Name",
      first_name: "First Name",
      email: "Email",
      password: "Password Digest",
      phone_number: "Phone Number",
      profile_image_url: nil,
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
    expect(rendered).to match(/true/)
  end
  it "renders the professional's profile image" do
    expect(rendered).to have_css("img[src*='profile-placeholder.png']")
  end
end
