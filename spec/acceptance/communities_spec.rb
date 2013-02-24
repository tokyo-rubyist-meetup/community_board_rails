# encoding: UTF-8
require 'acceptance/acceptance_helper'

feature 'Create community' do
  scenario 'successfully' do
    sign_in create(:user)
    visit new_community_path
    fill_in "community_name", with: "Tokyo Rubyist Meetup"
    click_button "Create Community"
    page.find(".breadcrumb .active").text.should match "Tokyo Rubyist Meetup"
  end
end

