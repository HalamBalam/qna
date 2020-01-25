require 'rails_helper'

feature 'User can create an answer', %q{
  I'd like to be able to create an answer from the question's form.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can create an answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'New answer'
    click_on 'Reply'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'New answer'
  end

  scenario 'Authenticated user could not create invalid answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Reply'

    expect(page).to have_content "The answer is invalid."
  end

  scenario 'Unauthenticated user could not create an answer' do
    visit question_path(question)

    fill_in 'Body', with: 'New answer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
