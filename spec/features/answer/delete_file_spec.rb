require 'rails_helper'

feature 'User can delete attached to his answer files', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to remove attached files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  it_behaves_like 'deleting files' do
    given(:resource) { create(:answer, :with_attached_files, question: question) }
    given(:path) { question_path(question) }
    given(:html_class) { '.answers' }
  end
end
