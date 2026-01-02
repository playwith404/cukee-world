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
end
