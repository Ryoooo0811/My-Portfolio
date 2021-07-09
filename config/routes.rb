Rails.application.routes.draw do
  devise_for :users
  get "home/about" => "homes#about"
  root to: 'homes#top'
  resources :users, only: [:index, :show, :edit, :update] do
  # ——————————————— ここから ———————————————
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  # ——————————— ここまでネストさせる ———————————
  end
  resources :events
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
