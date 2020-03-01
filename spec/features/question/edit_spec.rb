require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  
  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end


  describe 'Authenticated user' do

    scenario 'edits his question', js: true do
      sign_in question.user
      visit question_path(question)
      
      click_on 'Edit question'

      within '.question' do
        fill_in 'New title', with: 'edited title'
        fill_in 'New body', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in question.user
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'New title', with: ''
        fill_in 'New body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user
      visit question_path(question)  
      expect(page).to_not have_link 'Edit question'
    end

  end

end
