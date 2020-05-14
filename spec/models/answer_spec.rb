require 'rails_helper'

RSpec.describe Answer, type: :model do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }
  let!(:reward) { create(:reward, question: question) }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'should be maximum one best answer' do
    answer1.best!
    expect(answer1).to be_best
    expect(answer2).not_to be_best

    answer2.best!
    answer1.reload
    expect(answer1).not_to be_best
    expect(answer2).to be_best   
  end

  it 'should give reward to the author of the best answer' do
    answer1.best!
    expect(reward.user_id).to eq answer1.user.id

    answer2.best!
    expect(reward.user_id).to eq answer2.user.id
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  
end
