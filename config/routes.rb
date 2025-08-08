Rails.application.routes.draw do
  resources :users
  resources :podcasts do
    get :deleted, on: :collection
    post :recover, on: :member
  end
  resource :session
  resources :passwords, param: :token

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end
