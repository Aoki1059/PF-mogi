Rails.application.routes.draw do

  namespace :public do
    get 'notifications/index'
  end
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    root to: "homes#top"
    resources :posts, only:[:index, :show, :edit, :destroy, :create, :update] do
      resources :bookmarks, only: [:index, :create, :destroy]
      resources :comments, only: [:create]
    end
    resources :comments, only: [:destroy]
    get "/customers/unsubscribe" => "customers#unsubscribe"
    patch "/customers/withdraw" => "customers#withdraw"
    resources :customers, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    get "search" => "searches#search"
  end

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get '/' => "homes#top"
    patch "/customers/withdraw" => "customers#withdraw"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :posts, only:[:index, :show, :destroy]
    get "search" => "searches#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
