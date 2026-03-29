Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    root "dashboard#index", as: :authenticated_root
    get "dashboard", to: "dashboard#index", as: :dashboard

    scope :auth do
      get  "quickbooks/connect",    to: "quickbooks_auth#connect",    as: :quickbooks_connect
      get  "quickbooks/callback",   to: "quickbooks_auth#callback",   as: :quickbooks_callback
      delete "quickbooks/disconnect", to: "quickbooks_auth#disconnect", as: :quickbooks_disconnect
      post   "quickbooks/sync",       to: "quickbooks_sync#create",    as: :quickbooks_sync
    end
  end

  root "devise/sessions#new"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
