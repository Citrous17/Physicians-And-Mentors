require 'rails_helper'

RSpec.describe "professionals/new", type: :view do
  let(:user) { create(:user, isProfessional: true) }

  before(:each) do
    assign(:professional, create(:user, isProfessional: true, profile_image_url: "profile-placeholder.png", first_name: "First Name", last_name: "Last Name", email: "Email", phone_number: "Phone Number"))
  end

  it "renders new professional form" do
    render

    assert_select "form[action=?][method=?]", professionals_path, "post" do
      assert_select "input[name=?]", "user[last_name]"

      assert_select "input[name=?]", "user[first_name]"

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[password]"

      assert_select "input[name=?]", "user[password_confirmation]"

      assert_select "input[name=?]", "user[phone_number]"

      assert_select "input[name=?]", "user[profile_image_url]"

      assert_select "input[name=?]", "user[isProfessional]"
    end
  end
end
