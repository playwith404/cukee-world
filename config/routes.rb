Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "pages#home"

  # Static pages
  get "about", to: "pages#about", as: :about
  get "services", to: "pages#services", as: :services
  get "pricing", to: "pages#pricing", as: :pricing
  get "contact", to: "pages#contact", as: :contact

  # Contact form
  resources :contacts, only: [ :new, :create ] do
    collection do
      get :thank_you
    end
  end

  # Console (Enterprise Dashboard)
  namespace :console do
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    get "dashboard", to: "dashboards#show", as: :dashboard
    root to: "dashboards#show"

    resources :api_usage, only: [ :index ]
    resources :billing, only: [ :index ]
    resources :api_keys, only: [ :index, :create, :destroy ] do
      member do
        patch :revoke
      end
    end
    resources :alerts, only: [ :index, :update ]
  end
end
