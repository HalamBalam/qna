class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth  = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first

    if authorization
      raise 'Email is not confirmed' if !authorization.confirmed?
      return authorization.user
    end

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth, true)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth, true)
    end
    user
  end
end
