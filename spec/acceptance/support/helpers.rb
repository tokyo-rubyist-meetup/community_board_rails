module HelperMethods
  def sign_in
    @user = create(:user)
    visit new_user_session_path
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: "password"
    click_button "Sign in"
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
