class Services::Notification
  def self.notify_question_subscribers(question)
    User.joins(:subscriptions).where(subscriptions: { question: question }).each do |user|
      NotificationMailer.notify_question_subscriber(user, question)
    end
  end
end
