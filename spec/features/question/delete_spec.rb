require 'rails_helper'

feature 'User can delete his question', %q{
  I'd like to be able to delete the questions, that I have created.
} do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User can delete his question' do
    question = create_question(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario "User could not delete another user's question" do
    question = create(:question)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'User is not the author of the question.'
  end
  
end
