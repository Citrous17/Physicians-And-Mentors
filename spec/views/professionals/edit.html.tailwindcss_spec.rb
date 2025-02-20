require 'rails_helper'

RSpec.describe "professionals/edit", type: :view do
  let(:professional) {
    Professional.create!(
      last_name: "MyString",
      first_name: "MyString",
      email: "MyString",
      password_digest: "MyString",
      phone_number: "MyString",
      profile_image_url: "MyString",
      isProfessional: false
    )
  }

  before(:each) do
    assign(:professional, professional)
  end

  it "renders the edit professional form" do
    render

    assert_select "form[action=?][method=?]", professional_path(professional), "post" do

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
