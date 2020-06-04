Rails.application.routes.draw do

  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      patch :vote_yes
      patch :vote_no
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, except: :index, concerns: [:votable, :commentable] do
      member do
        patch :mark_as_best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :links,       only: [:destroy]
  resources :rewards,     only: [:index]
  resources :votes,       only: [:destroy]

  resources :authorizations, only: [:create] do
    member do
      get :confirm_email
    end
  end

  mount ActionCable.server => '/cable'

end
