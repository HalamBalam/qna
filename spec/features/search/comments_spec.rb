require 'sphinx_helper'

feature 'User can search for comment', "
  In order to find needed comment
  As a User
  I'd like to be able to search for the comment
" do
  
  given!(:comment) { create(:comment, commentable: create(:question)) }

  scenario 'User searches for the comment', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'CommentBody'
      end

      fill_in 'q', with: 'CommentBody'
      choose 'Comments'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'CommentBody'
      end
    end
  end


  scenario 'User searches the entire DB for the comment', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'CommentBody'
      end

      fill_in 'q', with: 'CommentBody'
      choose 'All'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'CommentBody'
      end
    end
  end


  scenario 'User could not find the absent comment', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'No matches were found'
      end

      fill_in 'q', with: 'Absent comment'
      choose 'Comments'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'No matches were found'
      end
    end
  end
end
