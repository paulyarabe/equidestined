Rails.application.routes.draw do
  resources :locations
  resources :venues
  resources :searches
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "locations#index"
  get "/results", to: "locations#results"
end
