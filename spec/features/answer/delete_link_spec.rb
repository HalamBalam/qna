require 'rails_helper'

feature 'User can delete links from his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to remove links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  
  scenario 'Unauthenticated user can not delete links', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Remove link'
    end
  end


  scenario 'Authenticated user deletes link from his answer', js: true do
    sign_in answer.user
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'Thinknetica'

      click_on 'Remove link' 

      expect(page).to_not have_link 'Thinknetica' 
    end
  end


  scenario "Authenticated user can not delete a link from another user's answer", js: true do
    sign_in user
    visit question_path(question) 

    within '.answers' do
      expect(page).to_not have_link 'Remove link'
    end 
  end

end
