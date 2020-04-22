require 'rails_helper'

RSpec.describe User, type: :model do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { expect(answer.user).to be_author(answer) }
  it { expect(user).not_to be_author(answer) }
  it { expect(question.user).to be_author(question) }
  it { expect(user).not_to be_author(question) }

  it '#voted_for?' do
    expect(user).to_not be_voted_for(question)

    vote = create(:vote, votable: question, user: user, rating: 1)
    expect(user).to be_voted_for(question)
  end

  it 'vote' do
    vote = create(:vote, votable: question, user: user, rating: 1)
    expect(user.vote(question)).to eq vote  
  end

end
