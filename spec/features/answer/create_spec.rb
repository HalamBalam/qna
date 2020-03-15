require 'rails_helper'

feature 'User can create an answer', %q{
  I'd like to be able to create an answer from the question's form.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create an answer' do
      expect(page).to_not have_content 'New answer'

      fill_in 'Body', with: 'New answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'New answer'
      end
    end

    scenario 'can create an answer with attached files' do
      fill_in 'Body', with: 'New answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end  
    end

    scenario 'could not create invalid answer' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not create an answer' do
      visit question_path(question)
      expect(page).to_not have_button 'Answer'
    end
  end

end
