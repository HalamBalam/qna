class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)

    mail to: user.email
  end
end
