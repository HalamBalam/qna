require 'rails_helper'

feature 'User can add comments to questions', %q{
  In order to provide additional info to any question
  I'd like to be able to add comments
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }

  it_behaves_like 'creating comments' do
    given(:path) { question_path(question) }
    given(:guest_path) { question_path(question2) }
    given(:html_class) { ".question" }
    given(:guest_html_class) { ".question" }
  end
end
