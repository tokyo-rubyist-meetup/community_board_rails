require 'acceptance/acceptance_helper'
require 'capybara/json'

feature 'API' do
  include Capybara::Json
  background { Capybara.current_driver = :httpclient_json }
  let(:app) { create(:application) }
  let(:user) { create(:user) }
  let(:client) do
    OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  end
  let(:token) { client.password.get_token(user.email, user.password) }

  scenario('auth ok') { token.should_not be_expired }

  scenario('auth nok') { -> {client.password.get_token(user.email, "123")}.should raise_error(OAuth2::Error) }

  context "communities" do
    let!(:community) { create(:community) }
    scenario 'index' do
      get '/api/v1/communities'
      json["communities"].first["id"].should == community.id
    end
  end

  context "posts" do
    let(:community) { community_post.community }
    let!(:community_post) { create(:post) }

    scenario 'index' do
      get "/api/v1/communities/#{community.id}/posts"
      json["posts"].first["id"].should == community_post.id
    end

    scenario 'create' do
      post "/api/v1/communities/#{community.id}/posts", post: { text: "foo"}, access_token: token.token
      user.posts.count.should == 1
      user.posts.first.text.should == "foo"
    end
  end
end
