require 'rails_helper'

RSpec.describe "professionals/show", type: :view do
  before(:each) do
    @professional = assign(:professional, FactoryBot.create(:user, isProfessional: true, email: "john.doe@example.com")) # Other attributes defined in factory bot
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/john.doe@example.com/)
    expect(rendered).to match(/Yes/)
  end
end
