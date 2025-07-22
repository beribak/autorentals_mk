Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Car rental routes
  root "home#index"
  get "cars", to: "cars#index"
  get "cars/:id", to: "cars#show", as: :car
  get "contact", to: "home#contact", as: :contact

  # Booking routes
  resources :bookings do
    member do
      patch :cancel
    end
  end

  # Nested route for creating bookings from cars
  resources :cars, only: [] do
    resources :bookings, only: [ :new, :create ]
  end

  # AJAX route for checking availability
  get "check_availability", to: "bookings#check_availability"

  # Admin dashboard routes
  namespace :admin do
    resources :cars do
      member do
        patch :toggle_availability
      end
    end
    root "cars#index"
  end
end
