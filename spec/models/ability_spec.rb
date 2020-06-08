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
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }
    
    let(:question_vote) { create(:vote, votable: create(:question), user: user) }
    let(:answer_vote) { create(:vote, votable: create(:answer), user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to     :update, question }
    it { should_not be_able_to :update, create(:question) }
    it { should be_able_to     :update, answer }
    it { should_not be_able_to :update, create(:answer) }

    it { should be_able_to     :destroy, question }
    it { should_not be_able_to :destroy, create(:question) }
    it { should be_able_to     :destroy, answer }
    it { should_not be_able_to :destroy, create(:answer) }

    it { should be_able_to     :vote, create(:question) }
    it { should_not be_able_to :vote, question }
    it { should_not be_able_to :vote, question_vote.votable }
    it { should be_able_to     :vote, create(:answer) }
    it { should_not be_able_to :vote, answer }
    it { should_not be_able_to :vote, answer_vote.votable }

    it { should be_able_to     :revote, question_vote.votable }
    it { should_not be_able_to :revote, question }
    it { should_not be_able_to :revote, create(:question) }
    it { should be_able_to     :revote, answer_vote.votable }
    it { should_not be_able_to :revote, answer }
    it { should_not be_able_to :revote, create(:answer) }

    it { should be_able_to     :destroy, create(:question, :with_attached_files, user: user).files.first }
    it { should_not be_able_to :destroy, create(:question, :with_attached_files).files.first }
    it { should be_able_to     :destroy, create(:answer, :with_attached_files, user: user).files.first }
    it { should_not be_able_to :destroy, create(:answer, :with_attached_files).files.first }

    it { should be_able_to     :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question)) }
    it { should be_able_to     :destroy, create(:link, linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:answer)) }

    it { should be_able_to     :mark_answer_as_best, create(:answer, question: question) }
    it { should_not be_able_to :mark_answer_as_best, create(:answer) }
    it { should_not be_able_to :mark_answer_as_best, create(:answer, question: question, best: true) }
  end
end
