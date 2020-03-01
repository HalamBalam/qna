require 'rails_helper'

feature 'User can delete his answer', %q{
  I'd like to be able to delete the answers, that I have created.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do

    scenario 'can delete his answer', js: true do
      sign_in(answer.user)
      visit question_path(question)

      within '.answers' do      
        expect(page).to have_content answer.body

        click_on 'Delete'

        expect(page).to_not have_content answer.body
      end
    end

    scenario "could not delete another user's answer", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not delete answers', js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Delete'  
      end
    end
  end

end
