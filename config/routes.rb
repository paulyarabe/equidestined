Rails.application.routes.draw do
  #resources :locations
  resources :searches, only: [:new, :create, :show, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/start", to: "searches#new", as: 'start'
  #get "/results", to: "searches#show", as: 'results'
end
