require 'rails_helper'

RSpec.describe "professionals/edit", type: :view do
  let(:user) {
    User.create!(
      first_name: "John", last_name: "Doe", email: "john@example.com", password: "password", phone_number: "1234567890", isProfessional: true, DOB: "2000-01-01"
    )
  }

  before(:each) do
    assign(:professional, user)  # Change @user to @professional
  end

  it "renders the edit professional form" do
    render

    assert_select "form[action=?][method=?]", professional_path(user), "patch" do
      assert_select "input[name=?]", "user[last_name]"
      assert_select "input[name=?]", "user[first_name]"
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[password]"
      assert_select "input[name=?]", "user[phone_number]"
      assert_select "input[name=?]", "user[profile_image_url]"
      assert_select "input[name=?]", "user[isProfessional]"
    end
  end
end

