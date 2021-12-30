Rails.application.routes.draw do
  root to: 'wheather#index'

  resources :wheather, only: [:index]
  resources :temperature_configs, only: [:index, :new, :edit, :update, :create, :destroy]
end
