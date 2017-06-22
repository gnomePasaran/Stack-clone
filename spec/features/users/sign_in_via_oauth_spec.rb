require "rails_helper"

shared_examples "sign in via oauth" do
  given(:user) { create(:user) }

  background do
    OmniAuth.config.mock_auth[provider_sym] = nil
  end

  context "email provided" do
    scenario "new user" do
      mock_auth_hash(provider: provider_sym)
      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      expect(page).to have_content "Successfully authenticated from #{provider_name} account"
    end

    scenario "with existing identity" do
      mock_auth_hash(provider: identity.provider, uid: identity.uid, info: { email: identity.user.email })
      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      expect(page).to have_content "Successfully authenticated from #{provider_name} account"
    end

    scenario "user already exists, link with provider" do
      mock_auth_hash(provider: provider_sym, info: { email: user.email })

      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      expect(page).to have_content "Successfully authenticated from #{provider_name} account"
      expect(page).not_to have_content "Please enter your email address to continue registration"
    end
  end

  context "email not provided" do
    scenario "email already taken" do
      mock_auth_hash(provider: provider_sym, info: nil)

      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      sleep 0.5

      fill_in "Email", with: identity.user.email
      click_on "Continue"
      expect(page).to have_content "User with provided email already registered"
    end

    scenario "without email" do
      mock_auth_hash(provider: provider_sym, info: nil)

      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      sleep 0.5

      expect(page).to have_content "Please enter your email address to continue registration"

      fill_in "Email", with: "new@example.com"
      click_on "Continue"

      expect(page).to have_content "Successfully authenticated from #{provider_name} account"
      expect(page).to have_content "Sign out"
    end
  end

  scenario "view invalid_credentials error" do
    invalid_mock_auth_hash(provider_sym)
    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    sleep 0.5
    expect(page).to have_content "Invalid credentials"
  end

  context "redirections" do
    scenario "redirect if signed in" do
      sign_in user
      visit finish_signup_path
      expect(page).not_to have_content "Almost there"
    end

    scenario "redirect if no session with auth data" do
      visit finish_signup_path
      expect(page).not_to have_content "Almost there"
    end
  end
end

feature "Sign in via Oauth" do
  context "facebook provider" do
    let(:provider_sym) { :facebook }
    let(:provider_name) { "Facebook" }
    given!(:identity) { create(:identity, provider: provider_sym) }

    it_behaves_like "sign in via oauth"
  end

  context "twitter provider" do
    let(:provider_sym) { :twitter }
    let(:provider_name) { "Twitter" }
    given!(:identity) { create(:identity, provider: provider_sym) }

    it_behaves_like "sign in via oauth"
  end
end
