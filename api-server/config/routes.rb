ApiServer::Application.routes.draw do
  resources :players, only: [:create], defaults: {format: :json}
  resource :session, only: [:create, :destroy], defaults: {format: :json}
  resources :characters, only: [:index, :create], defaults: {format: :json}
end
