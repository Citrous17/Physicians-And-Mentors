require 'rails_helper'

RSpec.describe "professionals/edit", type: :view do
  before(:each) do
    @professional = assign(:user, User.create!(
      last_name: "Doe",
      first_name: "John",
      email: "john.doe@example.com",
      password: "password",
      phone_number: "1234567890",
      profile_image_url: "http://example.com/image.png",
      isProfessional: true
    ))
  end

  it "renders the edit professional form" do
    render

    assert_select "form[action=?][method=?]", professional_path(@professional), "post" do
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
