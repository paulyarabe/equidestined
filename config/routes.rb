Rails.application.routes.draw do
  #resources :locations
  resources :searches, only: [:new, :create, :show, :edit, :update, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/start", to: "searches#new", as: 'start'
  #get "/results", to: "locations#results"
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/sessions', to: 'sessions#destroy', as: 'logout'
end
