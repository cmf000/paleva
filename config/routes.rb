Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :restaurants do
    resources :dishes, only: [:new, :create, :edit, :update, :show] do
      post :toggle_status, on: :member
    end
    resources :beverages, only: [:new, :create, :edit, :update, :show] do
      post :toggle_status, on: :member
    end
    get :search, to: 'search#index'
  end
end
