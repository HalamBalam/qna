Rails.application.routes.draw do

  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :vote_yes
      patch :vote_no
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, except: :index, concerns: [:votable] do
      member do
        patch :mark_as_best
      end

      resources :comments, only: [:create], defaults: { context: 'answer' }
    end

    resources :comments, only: [:create], defaults: { context: 'question' }

    member do
      get :partial
    end
  end

  resources :attachments, only: [:destroy]
  resources :links,       only: [:destroy]
  resources :rewards,     only: [:index]
  resources :votes,       only: [:destroy]

  mount ActionCable.server => '/cable'

end
