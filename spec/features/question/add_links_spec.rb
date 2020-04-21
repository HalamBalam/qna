require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/HalamBalam/54d7c4f3e3b74eea57348ef9292fe780' }
  given(:url) { 'https://github.com/HalamBalam/' }

  
  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'github'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'github', href: url
  end


  scenario 'User adds gist link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'My gist'
    expect(page).to_not have_link 'My gist'
  end


  scenario 'User adds link when edit his question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'github'

      click_on 'Edit question'

      click_on 'add link'

      fill_in 'Link name', with: 'github'
      fill_in 'Url', with: url

      click_on 'Save'

      expect(page).to have_link 'github', href: url
    end
  end

end
