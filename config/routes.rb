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

  delete 'questions/:id/delete_file/:file_id', to: 'questions#delete_file', as: :question_delete_file
  delete 'answers/:id/delete_file/:file_id', to: 'answers#delete_file', as: :answer_delete_file

end
