require 'rails_helper'

feature 'User can delete his answer', %q{
  I'd like to be able to delete the answers, that I have created.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2) }

  describe 'Authenticated user' do
    background { sign_in(answers[0].user) }

    scenario 'can delete his answer' do
      visit answer_path(answers[0])
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).to_not have_content answers[0].body
    end

    scenario "could not delete another user's answer" do
      visit answer_path(answers[1])

      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not delete answers' do
      visit answer_path(answers[0])
      expect(page).to_not have_content 'Delete answer'  
    end
  end

end
