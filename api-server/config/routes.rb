ApiServer::Application.routes.draw do
  resources :players, only: [:create], defaults: {format: :json}
  resource :session, only: [:create, :destroy], defaults: {format: :json}
  resources :pcs, only: :index, defaults: {format: :json}
end
