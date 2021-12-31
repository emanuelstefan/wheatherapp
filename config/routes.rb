Rails.application.routes.draw do
  root to: 'wheather#index'

  resources :wheather, only: [:index]
  get '/wheather/getweatherinfo', to: 'wheather#getweatherinfo'

  resources :temperature_configs, only: [:index, :new, :edit, :update, :create, :destroy]
end
