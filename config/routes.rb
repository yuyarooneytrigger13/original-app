Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  resources :homes, only: [:index]
  resources :plans, only: [:index]
  
end
