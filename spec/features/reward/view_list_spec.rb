require 'rails_helper'

feature 'User can see his rewards', %q{
  I'd like to be able to see my rewards
} do

  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:reward) { create(:reward, user_id: user1.id) }

  scenario "User can not see other user's rewards", js: true do
    sign_in(user2)
    visit rewards_path

    expect(page).to_not have_content reward.question.title
    expect(page).to_not have_link reward.name
  end

  scenario "User can see his rewards", js: true do
    sign_in(user1)
    visit rewards_path

    expect(page).to have_content reward.question.title
    expect(page).to have_link reward.name
  end

end
