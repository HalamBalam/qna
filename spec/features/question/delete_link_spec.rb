require 'rails_helper'

feature 'User can delete links from his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to remove links
} do
  given!(:user) { create(:user) }

  it_behaves_like 'deleting links' do
    given!(:linkable) { create(:question) }
    given(:path) { question_path(linkable) }
    given(:html_class) { '.question' }
  end
end
