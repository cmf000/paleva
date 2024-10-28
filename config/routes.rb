Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :restaurants

  resources :restaurants do
    resources :dishes, only: [:new, :create, :edit, :update]
    resources :beverages, only: [:new, :create, :edit, :update]
    get :search, to: 'search#index'
  end
end
