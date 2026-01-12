Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  resources :plans do
    resources :destinations do
      member do
        post 'update_likes'
      end
    end
    resources :schedules
    resources :availabilities
    resources :candidates
    
  end
  resources :visited_records, only: [:index, :create, :destroy]

  
end
