require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls Services::Notification#notify_question_subscribers' do
    expect(Services::Notification).to receive(:notify_question_subscribers).with(answer.question)
    NotificationJob.perform_now(answer.question)
  end
end
