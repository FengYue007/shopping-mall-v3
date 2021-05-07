Rails.application.routes.draw do
  devise_for :users

  root 'store#home'
  resources :products
  resources :line_items
  resource :cart, only: [:show, :destroy] do
    collection do
      get :checkout   #/cart/checkout
    end
  end

  resources :orders, only: [:index, :show, :create]
end
