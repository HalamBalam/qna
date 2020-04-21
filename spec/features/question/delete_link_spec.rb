require 'rails_helper'

feature 'User can delete links from his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to remove links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:link) { create(:link, linkable: question) }


  scenario 'Unauthenticated user can not delete files', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Remove link'
    end
  end


  scenario 'Authenticated user deletes link from his question', js: true do
    sign_in question.user
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'Thinknetica'

      click_on 'Remove link' 

      expect(page).to_not have_link 'Thinknetica' 
    end
  end


  scenario "Authenticated user can not delete link from another user's question", js: true do
    sign_in user
    visit question_path(question) 

    within '.question' do
      expect(page).to_not have_link 'Remove link'
    end 
  end

end
