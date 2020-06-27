require 'rails_helper'

feature 'User can delete links from his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to remove links
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  
  it_behaves_like 'deleting links' do
    given!(:linkable) { create(:answer, question: question) }
    given(:path) { question_path(question) }
    given(:html_class) { '.answers' }
  end
end
