require "rails_helper"

feature "User sign out" do
  given(:user) { create(:user) }

  scenario "Logged in user signs out" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
    click_on "Sign out"

    expect(page).to have_content "Signed out successfully."
    expect(current_path).to eq root_path
  end
end
