require 'rails_helper'

RSpec.describe User, type: :model do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { expect(answer.user).to be_author(answer) }
  it { expect(user).not_to be_author(answer) }
  it { expect(question.user).to be_author(question) }
  it { expect(user).not_to be_author(question) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#voted_for?' do
    it 'votes for the question' do
      expect(user).to_not be_voted_for(question)

      vote = create(:vote, votable: question, user: user, rating: 1)
      expect(user).to be_voted_for(question)
    end
  end

  describe '#vote' do
    it 'returns correct vote' do
      vote = create(:vote, votable: question, user: user, rating: 1)
      expect(user.vote(question)).to eq vote  
    end
  end

end
