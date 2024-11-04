Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :restaurants do 
    resources :dishes, only: [:new, :create, :edit, :update, :show] do
      member do
        post :toggle_status
      end

      resources :offerings, only: [:new, :create, :edit, :update, :show]
    end   
    resources :beverages, only: [:new, :create, :edit, :update, :show] do  
      member do
        post :toggle_status
      end
      resources :offerings, only: [:new, :create, :edit, :update, :show]
    end
    get :search, to: 'search#index'
  end
  resources :tags, only: [:new, :create]
end
