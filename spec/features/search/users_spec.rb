require 'sphinx_helper'

feature 'User can search for user', "
  In order to find needed user
  As a User
  I'd like to be able to search for the user
" do
  
  given!(:user) { create(:user) }

  scenario 'User searches for the user', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content user.email
      end

      fill_in 'q', with: user.email
      choose 'Users'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content user.email
      end
    end
  end


  scenario 'User searches the entire DB for the user', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content user.email
      end

      fill_in 'q', with: user.email
      choose 'All'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content user.email
      end
    end
  end


  scenario 'User could not find the absent user', sphinx: true do
    visit search_path

    ThinkingSphinx::Test.run do
      within '.result' do
        expect(page).to_not have_content 'No matches were found'
      end

      fill_in 'q', with: 'Absent user'
      choose 'Users'
      
      click_on 'Find'

      within '.result' do
        expect(page).to have_content 'No matches were found'
      end
    end
  end
end
