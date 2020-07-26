require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do
  
  given!(:answer) { create(:answer) }

  scenario 'User searches for the answer', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'AnswerBody'
      end

      fill_in 'q', with: 'AnswerBody'
      choose 'Answers'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'AnswerBody'
      end
    end
  end


  scenario 'User searches the entire DB for the answer', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'AnswerBody'
      end

      fill_in 'q', with: 'AnswerBody'
      choose 'All'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'AnswerBody'
      end
    end
  end


  scenario 'User could not find the absent answer', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'No matches were found'
      end

      fill_in 'q', with: 'Absent answer'
      choose 'Answers'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'No matches were found'
      end
    end
  end
end
