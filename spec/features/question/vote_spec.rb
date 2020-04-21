require 'rails_helper'

feature 'User can vote for the question they like or dislike', %q{
  I'd like to be able to vote for the questions
  that I like and dislike.
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "user votes 'like' for another user's question", js: true do
    sign_in user
    visit question_path(question)

    expect(page).to have_content 'Rating: 0'
    expect(page).to have_link '+1'

    click_on '+1'

    expect(page).to have_content 'Rating: 1'
    expect(page).to_not have_link '+1'
  end


  scenario "user votes 'dislike' for another user's question", js: true do
    sign_in user
    visit question_path(question)

    expect(page).to have_content 'Rating: 0'
    expect(page).to have_link '-1'

    click_on '-1'

    expect(page).to have_content 'Rating: -1'
    expect(page).to_not have_link '-1'
  end


  scenario 'user re-votes for the question', js: true do
    create(:vote, votable: question, user: user, rating: 1)
    
    sign_in user
    visit question_path(question)

    expect(page).to have_content 'Rating: 1'
    expect(page).to have_link 're-vote'

    click_on 're-vote'

    expect(page).to have_content 'Rating: 0'
    expect(page).to_not have_link 're-vote'
  end


  scenario 'user could not vote for his question', js: true do
    sign_in question.user
    visit question_path(question)

    expect(page).to_not have_link '+1'
    expect(page).to_not have_link '-1'
  end


  scenario 'unauthenticated user could not vote', js: true do
    visit question_path(question)

    expect(page).to_not have_link '+1'
    expect(page).to_not have_link '-1'
  end

end
