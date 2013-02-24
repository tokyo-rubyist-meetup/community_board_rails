CommunityBoard::Application.routes.draw do
  devise_for :users
  resources :communities do
    resources :posts
  end
  root to: 'home#index'
end
