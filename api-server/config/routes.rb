ApiServer::Application.routes.draw do
  root to: 'characters#index'
  resources :players, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :characters, only: [:index, :create, :destroy]
end
