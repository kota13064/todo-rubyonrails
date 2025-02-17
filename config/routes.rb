Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :tasks
  resources :tags, only: %i[index create]

  namespace :admin do
    resources :users
  end

  get '/login', to: 'user_sessions#new', as: 'login'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy', as: 'logout'
end
