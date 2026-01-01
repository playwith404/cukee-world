Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "pages#home"

  # Static pages
  get "features", to: "pages#features", as: :features
  get "pricing", to: "pages#pricing", as: :pricing

  # Contact form
  resources :contacts, only: [ :new, :create ] do
    collection do
      get :thank_you
    end
  end
end
