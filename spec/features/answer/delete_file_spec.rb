require 'rails_helper'

feature 'User can delete attached to his answer files', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to remove attached files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_attached_files, question: question) }


  scenario 'Unauthenticated user can not delete files' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete file'
    end
  end


  scenario 'Authenticated user deletes file from his answer', js: true do
    sign_in answer.user
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete file', match: :first 

      expect(page).to_not have_link 'rails_helper.rb' 
    end
  end


  scenario "Authenticated user can not delete a file from another user's answer", js: true do
    sign_in user
    visit question_path(question) 

    within '.answers' do
      expect(page).to_not have_link 'Delete file'
    end 
  end
end
