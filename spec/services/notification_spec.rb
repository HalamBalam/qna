require 'rails_helper'

RSpec.describe Services::Notification do
  let(:question) { create_list(:question, 3) }

  it 'sends notification to all subscribers' do
    Subscription.all.each do |subscription|
      expect(NotificationMailer).to receive(:notify_question_subscriber).with(subscription.user, subscription.question).and_call_original
    end
    
    Services::Notification.notify_question_subscribers(question)
  end
end
