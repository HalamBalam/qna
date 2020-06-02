require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Registered user tries to sign in with wrong password' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'  
  end

  scenario 'Sign in with Github' do
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account'
    expect(page).to have_content 'mockuser@github.com'
  end

  scenario 'User could not sign in with invalid Github account' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Could not authenticate you from GitHub'
    expect(page).to_not have_content 'mockuser@github.com'
  end

  scenario 'Sign in with VK' do
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from VK account'
    expect(page).to have_content 'mockuser@vk.com'
  end

  scenario 'User could not sign in with invalid VK account' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Could not authenticate you from Vkontakte'
    expect(page).to_not have_content 'mockuser@vk.com'
  end

  scenario 'Sign in with VK without email' do
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '12345',
      'info' => {
        'name' => 'mockuser',
        'image' => 'mockuser_avatar_url'
      }
    })

    click_on 'Sign in with Vkontakte'
    expect(page).to have_content 'Enter email address for confirm registration'

    fill_in 'Email', with: 'test@vk.com'
    click_on 'Send'

    open_email('test@vk.com')

    expect(current_email).to have_content 'Confirm this email address'
    
    current_email.click_link 'Confirm'

    expect(page).to have_content 'Welcome, test@vk.com'
  end
end
