Rails.application.routes.draw do
  resources :users do
    # get 'index', on: :collection
    member do 
      get 'confirm_destroy'
    end
  end
  # get "users/index"
  # get "users/new"
  # get "users/edit"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get '/auth/:provider/callback', to: 'login#omniauth'
  get 'home', to: 'home#index'
  get 'login', to: 'login#new'
  post "/login", to: "sessions#create"
  delete '/logout', to: 'sessions#destroy'
  get 'users', to: 'users#index'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
