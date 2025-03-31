Rails.application.routes.draw do
  resources :professionals do
    member do
      get 'confirm_destroy'
    end
  end
  resources :users do
    # get 'index', on: :collection
    member do 
      get 'confirm_destroy'
    end
  end
  resources :posts, only: [:index, :new, :create, :show] do
    post :create_comment, on: :member
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

  get 'clear', to: 'users#clear'

  get '/auth/:provider/callback', to: 'login#omniauth'
  get 'home', to: 'home#index'
  get 'help', to: 'home#help'
  get 'login', to: 'login#new'
  post "/login", to: "sessions#create"
  delete '/logout', to: 'sessions#destroy'
  get 'users', to: 'users#index'
  get 'professionals', to: 'professionals#index'

  get 'admin/dashboard', to: 'admin#dashboard'
  get 'admin/users', to: 'admin#users'
  get 'admin/database', to: 'admin#database'
  post "/admin/invite_admin", to: "admin#invite_admin", as: :admin_invite_admin
  post "/admin/create_invite_code", to: "admin#create_invite_code", as: :admin_create_invite_code

  get "/signup", to: "login#signup"       # Show signup form
  post "/signup", to: "login#create"   # Handle form submission



  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
