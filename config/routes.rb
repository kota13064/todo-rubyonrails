Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :tasks

  get '/login', to: 'user_sessions#new', as: 'login'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'
end
