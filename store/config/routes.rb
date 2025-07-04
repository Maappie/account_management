Rails.application.routes.draw do

  root "home#index"
   
  resources :accounts, only: [:new, :create, :index]

  get "accounts/verify_code", to: "accounts#verify_code" , as: "verify_account"
  post "accounts/verify_code", to: "accounts#process_verification"
  post 'accounts/resend_email', to: 'accounts#resend_email', as: 'resend_account_email'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
