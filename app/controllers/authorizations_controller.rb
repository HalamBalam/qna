class AuthorizationsController < ApplicationController

  skip_authorization_check
  
  def create
    email = authorization_params[:email]
    user = User.find_by(email: email)

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    
    authorization = Authorization.find_by(provider: authorization_params[:provider], uid: authorization_params[:uid])
    authorization = user.create_authorization(authorization_params, false) unless authorization
    
    if authorization
      AuthorizationsMailer.email_confirmation(authorization).deliver_now
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def confirm_email
    auth = Authorization.find(params[:id])
    auth.confirmed = true
    auth.save

    sign_in_and_redirect auth.user, event: :authentication
  end

  private

  def authorization_params
    params.require(:authorization).permit(:email, :provider, :uid)
  end

end
