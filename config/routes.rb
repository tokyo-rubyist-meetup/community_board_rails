CommunityBoard::Application.routes.draw do
  use_doorkeeper

  devise_for :users
  namespace "api" do
    namespace "v1" do
      resources :communities, only: :index do
        resources :posts, only: %w[index create]
      end
    end
  end
  resources :communities do
    resources :posts
  end
  root to: 'communities#index'
end
