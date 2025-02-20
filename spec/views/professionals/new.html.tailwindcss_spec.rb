require 'rails_helper'

RSpec.describe "professionals/new", type: :view do
  before(:each) do
    assign(:professional, Professional.new(
      last_name: "MyString",
      first_name: "MyString",
      email: "MyString",
      password_digest: "MyString",
      phone_number: "MyString",
      profile_image_url: "MyString",
      isProfessional: false
    ))
  end

  it "renders new professional form" do
    render

    assert_select "form[action=?][method=?]", professionals_path, "post" do

      assert_select "input[name=?]", "professional[last_name]"

      assert_select "input[name=?]", "professional[first_name]"

      assert_select "input[name=?]", "professional[email]"

      assert_select "input[name=?]", "professional[password_digest]"

      assert_select "input[name=?]", "professional[phone_number]"

      assert_select "input[name=?]", "professional[profile_image_url]"

      assert_select "input[name=?]", "professional[isProfessional]"
    end
  end
end
