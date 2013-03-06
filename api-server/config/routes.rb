ApiServer::Application.routes.draw do
  resources :pcs, only: :index, defaults: {format: :json}
end
