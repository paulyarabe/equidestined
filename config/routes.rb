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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/start", to: "searches#new", as: 'start'
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/sessions', to: 'sessions#destroy', as: 'logout'

end
