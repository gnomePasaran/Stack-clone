require "rails_helper"

describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #finish_signup' do
    context "as user" do
      before do
        sign_in user
        get :finish_signup
      end

      it { should redirect_to root_path }
    end

    context "as guest" do
      context "with omniauth_data in session" do
        before do
          session["devise.oauth_data"] = { provider: "facebook" }
          get :finish_signup
        end

        it { should render_template :finish_signup }
      end

      context "without omniauth_data in session" do
        before do
          get :finish_signup
        end

        it { should redirect_to root_path }
      end
    end
  end

  describe 'PATCH #send_confirmation_email' do
    context "as user" do
      before { sign_in user }
      it "redirects to new_user_session_path" do
        patch :send_confirmation_email
        expect(response).to redirect_to root_path
      end
    end

    context "as guest" do
      context "without omniauth_data in session" do
        before do
          patch :send_confirmation_email
        end

        it { should redirect_to root_path }
      end

      context "with omniauth_data in session" do
        subject(:valid_submit) { patch :send_confirmation_email, params: { email: "test@example.com" } }

        before do
          session["devise.oauth_data"] = { "provider" => "facebook", "uid" => "123" }
        end

        it "renders finish_signup template" do
          patch :send_confirmation_email
          expect(response).to render_template :finish_signup
        end

        it "assigns user" do
          patch :send_confirmation_email
          expect(assigns(:user)).to be_a User
        end

        it "does not creates user" do
          expect { patch :send_confirmation_email }.not_to change(User, :count)
        end

        it "does not creates identites" do
          expect { patch :send_confirmation_email }.not_to change(Identity, :count)
        end

        it "does not creates user if exists" do
          user
          expect { patch :send_confirmation_email, params: { email: user.email } }.not_to change(User, :count)
        end

        it "creates user" do
          expect { valid_submit }.to change(User, :count).by(1)
        end

        it "creates user with submitted email" do
          valid_submit
          expect(assigns(:user).email).to eq "test@example.com"
        end

        it "creates identities" do
          expect { valid_submit }.to change(Identity, :count).by(1)
        end
      end
    end
  end
end
