class AuthorizationsMailer < ApplicationMailer

  def email_confirmation(authorization)
    @auth = authorization
    mail to: @auth.user.email, subject: 'Confirm your email address'
  end

end
