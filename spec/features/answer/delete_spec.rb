require 'rails_helper'

feature 'User can delete his answer', %q{
  I'd like to be able to delete the answers, that I have created.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario 'User can delete his answer' do
    answer = create_answer(user, question)

    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully deleted.'
  end

  scenario "User could not delete another user's answer" do
    answer = create(:answer)

    visit answer_path(answer)
    click_on 'Delete answer'

    expect(page).to have_content 'User is not the author of the answer.'
  end

end
