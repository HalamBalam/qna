require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to help other users
  As an author of the question
  I'd like to be able to choose the best answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'Unauthenticated user can not mark answers' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    scenario 'choose the best answer for his question', js: true do
      sign_in question.user
      visit question_path(question)
      
      within ".answer-#{answer1.id}" do
        click_on 'Mark as best'
        expect(page).to have_content 'This answer is the best!'
        expect(page).to_not have_link 'Mark as best'
      end

      within ".answer-#{answer2.id}" do
        expect(page).to have_link 'Mark as best'
      end

      within '.answers' do
        expect(all('div').first).to have_content 'This answer is the best!'
      end
    end

    scenario "tries to choose the best answer for other user's question", js: true do
      sign_in user
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best' 
    end
  end

end
