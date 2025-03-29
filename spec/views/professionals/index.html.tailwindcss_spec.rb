require 'rails_helper'

RSpec.describe "professionals/index", type: :view do
  before(:each) do
    assign(:professionals, create_list(:user, 2, last_name: "Last Name", first_name: "First Name", isProfessional: true, DOB: Date.parse("2024-07-07")))
  end

  it "renders a list of professionals" do
    render
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "First Name".to_s, count: 2
  end
end
