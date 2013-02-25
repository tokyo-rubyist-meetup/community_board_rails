# encoding: UTF-8
require 'acceptance/acceptance_helper'

feature 'Create community' do
  scenario 'successfully' do
    sign_in
    visit new_community_path
    fill_in "community_name", with: "Tokyo Rubyist Meetup"
    attach_file 'community_photo', Rails.root.join("spec/fixtures/trbmeetup.jpeg")
    click_button "Create Community"
    page.find(".breadcrumb .active").text.should match "Tokyo Rubyist Meetup"
  end
end

