shared_examples_for 'model votable' do
  it { should have_many(:votes).dependent(:destroy) }

  it '#rating' do
    expect(votable.rating).to eq 0

    vote = create(:vote, votable: votable, rating: 1)
    expect(votable.rating).to eq 1
  end
end
