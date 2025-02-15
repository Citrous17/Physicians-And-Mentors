require 'rails_helper'

RSpec.describe 'Creating a user', type: :feature do
  scenario 'valid inputs' do
    visit new_user_path
    fill_in "user[first_name]", with: 'examplefirstname'
    fill_in "user[last_name]", with: 'examplelastname'
    fill_in "user[email]", with: 'email@provider.com'
    fill_in "user[password_digest]", with: 'mypassword'
    select '2025', from: 'user[DOB(1i)]' 
    select 'January', from: 'user[DOB(2i)]' 
    select '1', from: 'user[DOB(3i)]' 
    fill_in "user[phone_number]", with: '999999999'
    fill_in "user[profile_image_url]", with: 'profile.image.link'
    fill_in "user[isProfessional]", with: 'false'
    click_on 'Create User'
    visit users_path

    expect(page).to have_content('examplefirstname')
    expect(page).to have_content('examplelastname')
    expect(page).to have_content('email@provider.com')
    expect(page).to have_content('2025-01-01')
    expect(page).to have_content('999999999')
    expect(page).to have_content('profile.image.link')
    expect(page).to have_content('false')
  end
end