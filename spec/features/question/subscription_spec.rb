require 'rails_helper'

feature 'Users can subscribe to any question they like', %q{
  I'd like to be able to subscribe and unsunscribe to any question.
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'user subscribes to the question', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_link 'unsubscribe'
    
    click_on 'subscribe!'

    expect(page).to have_link 'unsubscribe'
    expect(page).to_not have_link 'subscribe!'
  end

  scenario 'user unsubscribes from the question', js: true do
    create(:subscription, user: user, question: question)

    sign_in user
    visit question_path(question)

    expect(page).to_not have_link 'subscribe!'
    
    click_on 'unsubscribe'

    expect(page).to have_link 'subscribe!'
    expect(page).to_not have_link 'unsubscribe'
  end
end
