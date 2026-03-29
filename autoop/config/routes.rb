Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    root "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  root "devise/sessions#new"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
