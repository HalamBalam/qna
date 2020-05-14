require 'rails_helper'

feature 'User can add comments to answers', %q{
  In order to provide additional info to any answer
  I'd like to be able to add comments
} do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create a comment to the answer' do
      expect(page).to_not have_content 'New comment'

      within ".answer-#{answer.id}" do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Create Comment'

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'could not create invalid comment' do
      within ".answer-#{answer.id}" do
        click_on 'Add comment'
        click_on 'Create Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end


  describe 'multiple sessions' do
    scenario "comment appears on another user's page near the same answer", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".answer-#{answer.id}" do
          click_on 'Add comment'
          fill_in 'Comment', with: 'New comment'
          click_on 'Create Comment'

          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within ".answer-#{answer.id}" do
          expect(page).to have_content 'New comment'
        end
      end
    end


    scenario "comment does not appear on another user's page near the different answer", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".answer-#{answer.id}" do
          click_on 'Add comment'
          fill_in 'Comment', with: 'New comment'
          click_on 'Create Comment'

          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within ".answer-#{answer2.id}" do
          expect(page).to_not have_content 'New comment'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'could not create a comment' do
      visit question_path(question)
      expect(page).to_not have_button 'Add comment'
    end
  end

end
