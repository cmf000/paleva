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
    get :search, on: :member
    member do
      get :manage_employees
    end
    resources :new_employees, only: [:new, :create]
    resources :tags, only: [:new, :create]
  end
end
