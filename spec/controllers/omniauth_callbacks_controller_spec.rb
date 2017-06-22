require "rails_helper"

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    context "signed_in" do
      before do
        sign_in user
        get :facebook
      end

      it { should respond_with(302) }
      it { should redirect_to root_path }
    end

    context "identity exists" do
      let(:identity) { create(:identity, user: user) }

      before do
        stub_env_for_omniauth(provider: identity.provider, uid: identity.uid, info: { email: user.email })
        get :facebook
      end

      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end

    context "user exists" do
      let(:user) { create(:user, email: "test@example.com") }
      before do
        stub_env_for_omniauth(info: { email: user.email })
        get :facebook
      end

      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end

    context "user not exists" do
      context "email provided" do
        before do
          stub_env_for_omniauth
          get :facebook
        end

        it { should be_user_signed_in }
        it { should redirect_to root_path }
      end

      context "email not provided" do
        before do
          stub_env_for_omniauth(info: nil)
          get :facebook
        end

        it "stores data in session" do
          hash = stub_env_for_omniauth
          expect(session["devise.oauth_data"][:provider]).to eq hash.provider
          expect(session["devise.oauth_data"][:uid]).to eq hash.uid
        end

        it { should_not be_user_signed_in }
        it { should redirect_to finish_signup_path }
      end
    end
  end

  describe 'GET #twitter' do
    context "signed_in" do
      before do
        sign_in user
        get :twitter
      end

      it { should respond_with(302) }
      it { should redirect_to root_path }
    end

    context "identity exists" do
      let(:identity) { create(:identity, user: user) }

      before do
        stub_env_for_omniauth(provider: identity.provider, uid: identity.uid, info: { email: user.email })
        get :twitter
      end

      it { should be_user_signed_in }
      it { should redirect_to root_path }
    end

    context "user not exists" do
      context "email not provided" do
        before do
          stub_env_for_omniauth(provider: "twitter", info: nil)
          get :twitter
        end

        it "stores data in session" do
          hash = stub_env_for_omniauth(provider: "twitter", info: nil)
          expect(session["devise.oauth_data"][:provider]).to eq hash.provider
          expect(session["devise.oauth_data"][:uid]).to eq hash.uid
        end

        it { should_not be_user_signed_in }
        it { should redirect_to finish_signup_path }
      end
    end
  end
end

def stub_env_for_omniauth(hash = {})
  hash = OmniAuth::AuthHash.new({ provider: "facebook", uid: "123", info: { email: "test@example.com" } }.merge(hash))
  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[hash.provider.to_sym] = hash
end
