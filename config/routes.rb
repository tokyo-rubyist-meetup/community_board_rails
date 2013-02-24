CommunityBoard::Application.routes.draw do
  devise_for :users
  resources :communities
  root to: 'home#index'
end
