require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'model votable' do
    let(:votable) { create(:question) }
  end

  it_behaves_like 'model commentable'

  it { should have_many(:answers).order(best: :desc, created_at: :desc).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'subscription' do
    let(:question) { build(:question) }

    it 'creates subscription' do
      expect { question.save! }.to change(Subscription, :count).by(1)
      
      expect(Subscription.first.user).to eq(question.user)
      expect(Subscription.first.question).to eq(question)
    end
  end
end
