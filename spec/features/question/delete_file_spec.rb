require 'rails_helper'

feature 'User can delete attached to his question files', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to remove attached files
} do
  given(:user) { create(:user) }

  it_behaves_like 'deleting files' do
    given(:resource) { create(:question, :with_attached_files) }
    given(:path) { question_path(resource) }
    given(:html_class) { '.question' }
  end
end
