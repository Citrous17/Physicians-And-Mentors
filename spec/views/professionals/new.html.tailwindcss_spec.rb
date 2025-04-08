require 'rails_helper'

RSpec.describe "professionals/new", type: :view do
  before(:each) do
    assign(:professional, User.new)
  end

  it "renders new professional form" do
    render

    assert_select "form[action=?][method=?]", professionals_path, "post" do
      assert_select "input[name=?]", "user[last_name]"
      assert_select "input[name=?]", "user[first_name]"
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[password]"
      assert_select "input[name=?]", "user[password_confirmation]"
    end
  end
end
