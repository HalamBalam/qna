require 'rails_helper'

feature 'User can delete attached to his question files', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to remove attached files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_attached_files) }


  scenario 'Unauthenticated user can not delete files', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete file'
    end
  end


  scenario 'Authenticated user deletes file from his question', js: true do
    sign_in question.user
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete file', match: :first 

      expect(page).to_not have_link 'rails_helper.rb' 
    end
  end


  scenario "Authenticated user can not delete a file from another user's question", js: true do
    sign_in user
    visit question_path(question) 

    within '.question' do
      expect(page).to_not have_link 'Delete file'
    end 
  end
end
