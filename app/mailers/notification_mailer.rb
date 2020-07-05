class NotificationMailer < ApplicationMailer
  def notify_question_subscriber(user, question)
    @question = question

    mail to: user.email, subject: 'There is a new answer for your question'
  end
end
