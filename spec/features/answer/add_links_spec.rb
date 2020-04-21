require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:gist_url) { 'https://gist.github.com/HalamBalam/54d7c4f3e3b74eea57348ef9292fe780' }
  given(:url) { 'https://github.com/HalamBalam/' }

  
  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'New answer'

    fill_in 'Link name', with: 'github'
    fill_in 'Url', with: url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'github', href: url
    end
  end


  scenario 'User adds gist link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'New answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_content 'My gist'
      expect(page).to_not have_link 'My gist'
    end
  end


  scenario 'User adds link when edit his answer', js: true do
    sign_in(answer.user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'github'

      click_on 'Edit'

      click_on 'add link'

      fill_in 'Link name', with: 'github'
      fill_in 'Url', with: url

      click_on 'Save'

      expect(page).to have_link 'github', href: url
    end
  end

end
