shared_examples_for 'model ability' do
  let(:own) { create(resource, user: user) }
  let(:vote) { create(:vote, votable: create(resource), user: user) }
  let(:model_klass) { resource.to_s.classify.constantize }

  context 'for user' do
    it { should be_able_to :create, model_klass }

    it { should be_able_to     :update, own }
    it { should_not be_able_to :update, create(resource) }

    it { should be_able_to     :destroy, own }
    it { should_not be_able_to :destroy, create(resource) }

    it { should be_able_to     :vote, create(resource) }
    it { should_not be_able_to :vote, own }
    it { should_not be_able_to :vote, vote.votable }

    it { should be_able_to     :revote, vote.votable }
    it { should_not be_able_to :revote, own }
    it { should_not be_able_to :revote, create(resource) }

    it { should be_able_to     :destroy, create(resource, :with_attached_files, user: user).files.first }
    it { should_not be_able_to :destroy, create(resource, :with_attached_files).files.first }

    it { should be_able_to     :destroy, create(:link, linkable: own) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(resource)) }
  end
end
