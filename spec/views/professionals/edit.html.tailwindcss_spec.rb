require 'rails_helper'

RSpec.describe "professionals/edit", type: :view do
  let(:user) {
    User.create!(
      last_name: "MyString",
      first_name: "MyString",
      email: "MyString",
      password: "MyString",
      phone_number: "MyString",
      profile_image_url: "MyString",
      isProfessional: true,
      DOB: Date.new(2024, 7, 15)
    )
  }

  before(:each) do
    assign(:user, user)
  end

  it "renders the edit professional form" do
    render

    assert_select "form[action=?][method=?]", professional_path(user), "post" do

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
