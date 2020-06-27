require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }

  it_behaves_like 'deleted attachments' do
    let(:resource) { :question }
  end

  it_behaves_like 'deleted attachments' do
    let(:resource) { :answer }
  end
end
