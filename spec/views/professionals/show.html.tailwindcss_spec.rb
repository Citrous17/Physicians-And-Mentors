require 'rails_helper'

RSpec.describe "professionals/show", type: :view do
  before(:each) do
    assign(:professional, create(:user, isProfessional: true, profile_image: "profile-placeholder.png", first_name: "First Name", last_name: "Last Name", email: "Email", phone_number: "Phone Number"))
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
