Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  resources :status, only: [:index] do
    collection do
      get "user"
    end
  end
end
