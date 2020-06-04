require "rails_helper"

RSpec.describe AuthorizationsMailer, type: :mailer do
  let(:authorization) { create(:authorization) }
  
  describe '#email_confirmation' do
    it "creates message to user's email" do
      message = AuthorizationsMailer.email_confirmation(authorization)

      expect(message.to).to be_include(authorization.user.email)
    end
  end

end
