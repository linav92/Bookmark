Rails.application.routes.draw do
  root 'home#index'
  resources :bookmarks
  resources :categories
  resources :kinds
  get '/api', to: 'api#api'
  get '/api/:id', to: 'api#apiID'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
