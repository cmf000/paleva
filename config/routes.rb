Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :restaurants do 
    resources :shifts, only: [:index, :create, :destroy]
    
    get :test, on: :member
    resources :dishes, only: [:new, :create, :edit, :update, :show] do
      member do
        post :toggle_status
      end

      resources :offerings, only: [:new, :create, :edit, :update, :show] do
        resources :order_offerings, only: [:new, :create]
      end
    end   
    resources :beverages, only: [:new, :create, :edit, :update, :show] do  
      member do
        post :toggle_status
      end
      resources :offerings, only: [:new, :create, :edit, :update, :show] do
        resources :order_offerings, only: [:new, :create]
      end
    end
    get :search, on: :member
    member do
      get :manage_employees
    end
    resources :new_employees, only: [:new, :create]
    resources :tags, only: [:new, :create]
    resources :menus, only: [:new, :create, :show] do
      resources :offerable_menus, only: [:new, :create, :destroy]
    end
    resources :orders, only: [:new, :create, :index, :show] do
      patch :send_to_kitchen, on: :member
      get :cancel, on: :member
      patch :update_status_to_cancelled, on: :member
    end
    resources :order_offerings, only: [:new, :create]
  end

  namespace :api do
    namespace :v1 do
      resources :restaurants, param: :code, only: [] do
        resources :orders, only: [:index, :show], param: :code do
          patch :preparing, on: :member
          patch :ready, on: :member
          patch :cancelled, on: :member
        end
      end
    end
  end
end
