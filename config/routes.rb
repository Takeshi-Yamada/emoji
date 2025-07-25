Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[show edit update], path: "profiles", as: "profiles"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "tags/autocomplete", to: "tags#autocomplete"
  # Defines the root path route ("/")
  root "questions#index"
  resources :questions, only: %i[index new create show edit update] do
    resources :answers, only: %i[index create]
    get :generate_hint, on: :collection
    get :give_up, on: :member
  end
  resources :users, only: %i[show edit update]

  get "terms", to: "static#terms"
  get "privacy", to: "static#privacy"
end
