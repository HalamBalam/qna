require 'rails_helper'

RSpec.describe Services::FulltextSearch do
  it 'searches the entire DB' do
    subject = Services::FulltextSearch.new('test', 'all')
    allow(ThinkingSphinx).to receive(:search).with('test', classes: [Question, Answer, Comment, User], page: 1)
    subject.call
  end

  it 'searches with correct scope' do
    subject = Services::FulltextSearch.new('test', 'questions')
    allow(Question).to receive(:search).with('test', page: 1)
    subject.call
  end
end
