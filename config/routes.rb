Rails.application.routes.draw do
  resources :searches, only: [:new, :create, :show, :index]
  resources :users, only: [:new, :create, :show, :index] do
    member do
      get :following, :followers, :searches
    end
    collection do
      get :searches, to: "searches#friends"
    end
  end

  get "/start", to: "searches#new", as: 'start'
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/sessions', to: 'sessions#destroy', as: 'logout'
  get 'about', to: 'static#about'
  #get "/results", to: "searches#show", as: 'results'
  get 'sample', to: 'searches#sample', as: 'sample'


end
