require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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

    resources :subscriptions, only: [:create]
  end

  resources :attachments,   only: [:destroy]
  resources :links,         only: [:destroy]
  resources :rewards,       only: [:index]
  resources :votes,         only: [:destroy]
  resources :subscriptions, only: [:destroy]

  resources :authorizations, only: [:create] do
    member do
      get :confirm_email
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
    end
  end

  get '/search', to: 'search#search'

  mount ActionCable.server => '/cable'

  root to: 'questions#index'
end
