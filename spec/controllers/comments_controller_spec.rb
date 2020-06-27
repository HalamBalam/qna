require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }

  it_behaves_like 'created comments' do
    let(:resource) { :question }
  end

  it_behaves_like 'created comments' do
    let(:resource) { :answer }
  end
end
