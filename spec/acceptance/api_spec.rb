require 'acceptance/acceptance_helper'
require 'capybara/json'

feature 'OAuth authorization' do
  let(:app) { create(:application) }
  let(:user) { create(:user) }

  scenario 'auth ok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    token = client.password.get_token(user.email, user.password)
    token.should_not be_expired
  end

  scenario 'auth nok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    lambda {client.password.get_token(user.email, "123")}.should raise_error(OAuth2::Error)
  end
end

feature 'communities' do
  include Capybara::Json
  before { Capybara.current_driver = :httpclient_json }
  let!(:community) { create(:community) }
  scenario 'index' do
    get '/api/v1/communities'
    json["communities"].first["id"].should == community.id
  end
end

feature 'posts' do
  include Capybara::Json
  before { Capybara.current_driver = :httpclient_json }
  let(:community) { community_post.community }
  let!(:community_post) { create(:post) }
  scenario 'index' do
    get "/api/v1/communities/#{community.id}/posts"
    json["posts"].first["id"].should == community_post.id
  end

  let(:app) { create(:application) }
  let(:user) { create(:user) }

  scenario 'auth ok' do
    client = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    token = client.password.get_token(user.email, user.password)
    token.should_not be_expired
    post "/api/v1/communities/#{community.id}/posts", post: { text: "foo"}, access_token: token.token
    #token.post "/api/v1/communities/#{community.id}/posts", body: { text: "foo"}
    user.posts.count.should == 1
    user.posts.first.text.should == "foo"
  end
end
