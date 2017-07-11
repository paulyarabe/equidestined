Rails.application.routes.draw do
  resources :searches
  resources :venues
  resources :locations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "midpoints#index"
end
