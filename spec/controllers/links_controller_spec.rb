require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }

  it_behaves_like 'deleted links' do
    let(:resource) { :question }
  end

  it_behaves_like 'deleted links' do
    let(:resource) { :answer }
  end
end
