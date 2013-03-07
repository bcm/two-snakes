ApiServer::Application.routes.draw do
  resource :session, only: [:create, :destroy], defaults: {format: :json}
  resources :pcs, only: :index, defaults: {format: :json}
end
