class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth, confirmed)
    authorizations.create(provider: auth[:provider], uid: auth[:uid], confirmed: confirmed)
  end

  def author?(item)
     item.user_id == id
  end

  def voted_for?(votable)
    vote(votable).present?
  end

  def vote(votable)
    votes.find_by(votable: votable)
  end

end
