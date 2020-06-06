class OauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_authorization_check

  def github
    user_auth('Github')
  end

  def vkontakte
    user_auth('VK')
  end

  private

  def user_auth(description)
    auth = request.env['omniauth.auth']
    
    if auth[:info][:email].nil?
      @authorization = Authorization.find_by(provider: auth[:provider], uid: auth[:uid])

      if !@authorization || !@authorization.confirmed?
        @authorization = Authorization.new(provider: auth[:provider], uid: auth[:uid])
        render 'authorizations/ask_user_email' and return
      end

      @user = @authorization.user
    end

    @user ||= User.find_for_oauth(auth)
    
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: description) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
