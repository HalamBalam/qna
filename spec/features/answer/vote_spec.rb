require 'rails_helper'

feature 'User can vote for the answer they like or dislike', %q{
  I'd like to be able to vote for the answers
  that I like and dislike.
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "user votes 'like' for another user's answer", js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Rating: 0'
      expect(page).to have_link '+1'

      click_on '+1'

      expect(page).to have_content 'Rating: 1'
      expect(page).to_not have_link '+1'
    end
  end


  scenario "user votes 'dislike' for another user's answer", js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Rating: 0'
      expect(page).to have_link '-1'

      click_on '-1'

      expect(page).to have_content 'Rating: -1'
      expect(page).to_not have_link '-1'
    end
  end


  scenario 'user re-votes for the answer', js: true do
    create(:vote, votable: answer, user: user, rating: 1)
    
    sign_in user
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content 'Rating: 1'
      expect(page).to have_link 're-vote'

      click_on 're-vote'

      expect(page).to have_content 'Rating: 0'
      expect(page).to_not have_link 're-vote'
    end
  end


  scenario 'user could not vote for his answer', js: true do
    sign_in answer.user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end


  scenario 'unauthenticated user could not vote', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end

end
