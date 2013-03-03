require 'acceptance/acceptance_helper'

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
