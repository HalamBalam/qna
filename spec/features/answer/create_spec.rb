require 'rails_helper'

feature 'User can create an answer', %q{
  I'd like to be able to create an answer from the question's form.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create an answer' do
      expect(page).to_not have_content 'New answer'

      fill_in 'Body', with: 'New answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'New answer'
    end

    scenario 'could not create invalid answer' do
      click_on 'Answer'
      expect(page).to have_content "The answer is invalid."
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not create an answer' do
      visit question_path(question)
      expect(page).to_not have_button 'Answer'
    end
  end

end
