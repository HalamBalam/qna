require 'rails_helper'

feature 'User can view all questions', %q{
  I'd like to be able to see all questions
} do

  given!(:questions) { create_list(:question, 2) }
  given(:user) { create(:user) }

  scenario 'Authenticated user can view questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'Unauthenticated user can view questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title 
  end
end
