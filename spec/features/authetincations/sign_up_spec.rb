require 'rails_helper'

feature 'New user can sign up', %q{
  I am a new user and I want to register in the system
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Sign up' 
  end

  scenario 'New user tries to sign up' do
    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end 

  scenario 'Existing user tries to sign up' do  
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Password confirmation is invalid' do
    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '1234567890'

    click_button 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end 

end
