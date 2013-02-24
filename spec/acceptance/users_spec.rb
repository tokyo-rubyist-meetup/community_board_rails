# encoding: UTF-8
require 'acceptance/acceptance_helper'

feature 'Account creation' do
  scenario 'successful' do
    visit root_path
    click_on "Register"
    fill_in "user_name", with: "田中太郎"
    fill_in "user_email", with: "test@example.org"
    fill_in "user_password", with: "password"
    click_button "Sign up"
    page.find(".alert").text.should match "Welcome! You have signed up successfully."
  end

end

