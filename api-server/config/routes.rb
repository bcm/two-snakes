ApiServer::Application.routes.draw do
  root to: 'sessions#new'
  resources :players, only: [:create]
  resource :session, only: [:new, :create, :destroy]
  resources :characters, only: [:index, :create, :destroy]
end
