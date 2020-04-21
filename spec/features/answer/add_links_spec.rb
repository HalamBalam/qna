require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:url) { 'https://github.com/HalamBalam/' }

  
  scenario 'User adds link when edit his answer', js: true do
    sign_in(answer.user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'github'

      click_on 'Edit'

      click_on 'add link'

      fill_in 'Link name', with: 'github'
      fill_in 'Url', with: url

      click_on 'Save'

      expect(page).to have_link 'github', href: url
    end
  end

end
