Rails.application.routes.draw do
  resources :professionals do
    member do
      get "confirm_destroy"
    end
  end
  resources :users do
    member do
      get "confirm_destroy"
    end
  end
  resources :specialties, only: [:index, :new, :create, :show, :destroy]
  resources :posts, only: [:index, :new, :create, :show] do
    post :create_comment, on: :member
  end
  # get "users/index"
  # get "users/new"
  # get "users/edit"
  get "home/index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"

  # User session routes
  get "/login", to: "sessions#new"       # Show login form
  post "/login", to: "sessions#create"   # Handle login form submission
  delete "/logout", to: "sessions#destroy" # Logout

  # Signup routes
  get "/signup", to: "sessions#signup"       # Show signup form
  post "/signup", to: "sessions#register"    # Handle signup form submission

  # OmniAuth callback
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/login")

  # Other routes
  get "clear", to: "users#clear"
  get "home", to: "home#index"
  get "help", to: "home#help"
  get "users", to: "users#index"
  get "professionals", to: "professionals#index"
  get "/newAuth", to: "users#newAuth", as: "new_auth"
  get "specialties", to: "specialties#index"

  # Admin routes
  get "admin/dashboard", to: "admin#dashboard"
  get "admin/users", to: "admin#users"
  get "admin/database", to: "admin#database"
  post "/admin/invite_admin", to: "admin#invite_admin", as: :admin_invite_admin
  post "/admin/create_invite_code", to: "admin#create_invite_code", as: :admin_create_invite_code
end
