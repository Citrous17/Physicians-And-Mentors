require 'rails_helper'

RSpec.describe 'Creating a physician', type: :feature do
  scenario 'valid inputs' do
    visit new_physician_path
    fill_in "physician[name]", with: 'example name'
    click_on 'Create Physician'
    visit physicians_path
    expect(page).to have_content('example name')
  end
end