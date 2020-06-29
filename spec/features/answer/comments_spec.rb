require 'rails_helper'

feature 'User can add comments to answers', %q{
  In order to provide additional info to any answer
  I'd like to be able to add comments
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  it_behaves_like 'creating comments' do
    given(:path) { question_path(question) }
    given(:guest_path) { question_path(question) }
    given(:html_class) { ".answer-#{answer.id}" }
    given(:guest_html_class) { ".answer-#{answer2.id}" }
  end
end
