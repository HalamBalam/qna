Rails.application.routes.draw do

  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true, except: :index do
      member do
        patch :mark_as_best
      end
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

end
