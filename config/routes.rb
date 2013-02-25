CommunityBoard::Application.routes.draw do
  devise_for :users
  resources :communities, except: :index do
    resources :posts
  end
  root to: 'communities#index'
end
