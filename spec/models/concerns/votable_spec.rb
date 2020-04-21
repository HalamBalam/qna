require 'rails_helper'

RSpec.shared_examples_for 'votable' do

  let(:model) { described_class }

  it { should have_many(:votes).dependent(:destroy) }

  it '#rating' do
    votable = create(model.to_s.underscore.to_sym)
    expect(votable.rating).to eq 0

    vote = create(:vote, votable: votable, rating: 1)
    expect(votable.rating).to eq 1
  end

end
