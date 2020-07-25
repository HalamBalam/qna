require 'sphinx_helper'

feature 'User can search for many questions', "
  In order to find needed questions
  As a User
  I'd like to be able to search for many questions
" do

  given!(:questions) { create_list(:question, 30) }

  scenario 'User searches for many questions', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_link 'Prev'
        expect(page).to_not have_link 'Next'
      end

      fill_in 'q', with: 'QuestionBody'
      choose 'Questions'

      click_on 'Find'

      within '.result' do
        expect(page.all('a', text: 'QuestionTitle').count).to eq 20
        click_on 'Next'

        expect(page.all('a', text: 'QuestionTitle').count).to eq 10
        expect(page).to_not have_link 'Next'

        click_on 'Prev'
        expect(page.all('a', text: 'QuestionTitle').count).to eq 20

        expect(page).to_not have_link 'Prev'
        expect(page).to have_link 'Next'
      end
    end
  end
end
