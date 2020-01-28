require 'rails_helper'

feature 'User can log out', %q{
  I can log out after logging in
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)
    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to log out' do
    visit root_path 
    expect(page).to_not have_content 'Log out' 
  end
  
end
