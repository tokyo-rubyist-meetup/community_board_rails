# encoding: UTF-8
require 'acceptance/acceptance_helper'

feature 'Create post' do
  background do
    community = create(:community)
    visit root_path
    sign_in
    visit community_path(community)
  end

  scenario 'successfully', js: true do
    fill_in "post_text", with: "This is a test"
    click_button "Post"
    page.should have_content "This is a test"
  end

  scenario 'with error', js: true do
    click_button "Post"
    page.should have_content "Text can't be blank"
  end
end

