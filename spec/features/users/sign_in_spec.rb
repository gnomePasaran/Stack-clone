require "rails_helper"

feature "User sign in" do
  given(:user) { create(:user) }

  scenario "User can visit login page through root_path" do
    visit root_path
    click_on "Sign in"
  end

  scenario "Registered user trying to sign in" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  scenario "Non-registered user trying to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "yest12@example.com"
    fill_in "Password", with: "12345678"
    click_button "Log in"

    expect(page).to have_content "Invalid Email or password."
    expect(current_path).to eq new_user_session_path
  end
end
