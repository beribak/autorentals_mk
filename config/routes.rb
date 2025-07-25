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

  # Booking inquiry routes (replaces old booking system)
  resources :booking_inquiries, only: [ :new, :create ] do
    collection do
      get :confirmation
    end
  end

  # Nested route for creating inquiries from cars
  resources :cars, only: [] do
    resources :booking_inquiries, only: [ :new, :create ], path: "inquiry"
  end

  # Keep booking routes for existing bookings (view only)
  resources :bookings, only: [ :index, :show ] do
    member do
      patch :cancel
    end
  end

  # AJAX route for checking availability (kept for compatibility)
  get "check_availability", to: "bookings#check_availability"

  # Admin dashboard routes
  namespace :admin, path: "admin_daniel" do
    resources :cars do
      member do
        patch :toggle_availability
        post :create_booking
        delete "bookings/:booking_id", action: :destroy_booking, as: :destroy_booking
      end
    end
    root "cars#index"
  end
end
