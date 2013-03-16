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
      json["communities"].size.should == 1
      community_json = json["communities"].first
      community_json["id"].should == community.id
      community_json["name"].should == community.name
      community_json["post_count"].should == community.posts.count
    end
  end

  context "posts" do
    let!(:community) { create(:community) }

    scenario 'index' do
      community_post = create(:post, user: user, community: community)
      get "/api/v1/communities/#{community.id}/posts"
      json["posts"].size.should == 1
      post_json = json["posts"].first
      post_json["id"].should == community_post.id
      post_json["text"].should == community_post.text
      user_json = post_json["user"]
      user_json["id"].should == user.id
      user_json["name"].should == user.name
      user_json["avatar_url"].should == "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}"
    end

    scenario 'create' do
      post "/api/v1/communities/#{community.id}/posts", post: { text: "foo"}, access_token: token.token
      user.posts.count.should == 1
      user.posts.first.text.should == "foo"
    end
  end
end
