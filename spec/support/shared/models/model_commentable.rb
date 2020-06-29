shared_examples_for 'model commentable' do
  it { should have_many(:comments).order(:created_at).dependent(:destroy) }
end
