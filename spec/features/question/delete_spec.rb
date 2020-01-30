require 'rails_helper'

feature 'User can delete his question', %q{
  I'd like to be able to delete the questions, that I have created.
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  describe 'Authenticated user' do
    background { sign_in(questions[0].user) }

    scenario 'can delete his question' do
      visit question_path(questions[0])
      expect(page).to have_content questions[0].body

      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content questions[0].body
    end

    scenario "could not delete another user's question" do
      visit question_path(questions[1])

      expect(page).to_not have_content 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not delete questions' do
      visit question_path(questions[0])
      expect(page).to_not have_content 'Delete question'  
    end
  end
  
end
