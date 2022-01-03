Rails.application.routes.draw do
  root to: 'weather#index'

  resources :weather, only: [:index]
  post '/weather/get_info', to: 'weather#get_info'

  resources :temperature_configs, only: [:index, :new, :edit, :update, :create, :destroy]
end
