require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }

  it_behaves_like 'deleted votes' do
    let(:votable) { create(:question) }
  end

  it_behaves_like 'deleted votes' do
    let(:votable) { create(:answer) }
  end
end
