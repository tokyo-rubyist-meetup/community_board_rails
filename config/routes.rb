CommunityBoard::Application.routes.draw do
  devise_for :users
  namespace "api" do
    namespace "v1" do
      resources :communities do
        resources :posts
      end
    end
  end
  resources :communities do
    resources :posts
  end
  root to: 'communities#index'
end
