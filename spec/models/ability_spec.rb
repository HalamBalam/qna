require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:subscription) { create(:subscription, user: user) }

    it_behaves_like 'model ability' do
      let(:resource) { :question }
    end

    it_behaves_like 'model ability' do
      let(:resource) { :answer }
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Comment }
    
    it { should be_able_to     :mark_answer_as_best, create(:answer, question: create(:question, user: user)) }
    it { should_not be_able_to :mark_answer_as_best, create(:answer) }
    it { should_not be_able_to :mark_answer_as_best, create(:answer, question: create(:question, user: user), best: true) }

    it { should be_able_to     :subscribe,   create(:question) }
    it { should_not be_able_to :subscribe,   create(:question, user: user) }
    it { should be_able_to     :unsubscribe, create(:question, user: user) }
    it { should_not be_able_to :unsubscribe, create(:question) }
  end
end
