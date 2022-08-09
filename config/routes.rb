Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'products#index'

  resources :products, only: [:index,:show]
  resources :categories, only: [:show]

  #cart 不需要多個，沒有id，使用單數
  resource :cart, only: [:show, :destroy] do
    collection do
      get :checkout
    end
  end

  resources :orders, except: [:new, :edit, :update, :destroy] do
    
    member do
      delete :cancel #orders/1/cancel
      post :pay #orders/1/pay
      get :pay_confirm #orders/1/pay_confirm
    end
    #orders/confirm
    collection do
      get :confirm
    end
  end
  
  namespace :admin do
    root "products#index" # /admin
    resources :products, except: [:show]
    resources :vendors, except: [:show]
    resources :categories, except: [:show] do
      # PUT /admin/categories/sort
      collection do
        put :sort
      end
    end
  end

  #POST/api/v1/subscribe
  namespace :api do
    namespace :v1 do
      post 'subscribe', to: 'utils#subscribe'
      post 'cart', to: 'utils#cart'
    end
  end
end
