Rails.application.routes.draw do
  resources :servers, except: [:show]
  resources :feeds, except: [:show]
  resources :users
  resources :podcasts do
    resources :episodes, except: [:index, :show]
  end
  get 'recover', to: 'recovery#index', as: :recovery
  post 'recover/:model/:id', to: 'recovery#recover', as: :recovery_recover
  resource :session
  resources :passwords, param: :token

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
