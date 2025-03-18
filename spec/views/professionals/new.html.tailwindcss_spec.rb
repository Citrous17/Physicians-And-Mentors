require 'rails_helper'

RSpec.describe "professionals/new", type: :view do
  before(:each) do
    assign(:professional, User.new(
      last_name: "MyString",
      first_name: "MyString",
      email: "MyString",
      password_digest: "MyString",
      phone_number: "MyString",
      profile_image_url: "MyString",
      isProfessional: true
    ))
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
