require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:identities).dependent(:destroy) }

  let(:email_regex) { /\Achange@me/ }
  let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123", info: { email: "test@example.com" }) }

  describe ".find_with_oauth" do
    context "registered" do
      let!(:user) { create(:user, email: "test@example.com") }

      it "returns user" do
        expect(described_class.find_for_oauth(auth)).to eq user
      end

      it "creates identity" do
        expect { described_class.find_for_oauth(auth) }.to change(user.identities, :count).by(1)
      end

      it "does not creates user" do
        expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
      end

      it "creates identity with provider and uid", :aggregate_failures do
        identity = described_class.find_for_oauth(auth).identities.first

        expect(identity.provider).to eq auth.provider
        expect(identity.uid).to eq auth.uid
      end
    end

    context "not registered" do
      context "with provided email" do
        it "returns user" do
          expect(described_class.find_for_oauth(auth)).to be_a described_class
        end

        it "creates user" do
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it "creates identity" do
          expect { described_class.find_for_oauth(auth) }.to change(Identity, :count).by(1)
        end

        it "creates identity with provider, uid and email", :aggregate_failures do
          identity = described_class.find_for_oauth(auth).identities.first

          expect(identity.provider).to eq auth.provider
          expect(identity.uid).to eq auth.uid
          expect(identity.user.email).to eq auth.info.email
        end
      end

      context "without email" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123") }

        it "returns nil" do
          expect(described_class.find_for_oauth(auth)).to eq nil
        end

        it "does not creates user" do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end
      end
    end
  end

  describe ".create_user_from_auth" do
    context "with email" do
      it "returns user" do
        expect(described_class.create_user_from_auth(auth)).to be_a described_class
      end

      it "creates user" do
        expect { described_class.create_user_from_auth(auth) }.to change(described_class, :count).by(1)
      end

      it "creates identity" do
        expect { described_class.create_user_from_auth(auth) }.to change(Identity, :count).by(1)
      end

      it "creates identity with provider, uid and email", :aggregate_failures do
        identity = described_class.create_user_from_auth(auth).identities.first

        expect(identity.provider).to eq auth.provider
        expect(identity.uid).to eq auth.uid
        expect(identity.user.email).to eq auth.info.email
      end

      it "skips confirmation" do
        expect(described_class.create_user_from_auth(auth).confirmed?).to be true
      end
    end

    context "without email" do
      let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123") }

      it "returns nil" do
        expect(described_class.find_for_oauth(auth)).to eq nil
      end
    end
  end

  describe ".create_user_from_session" do
    let(:email) { "test@example.com" }
    context "with email" do
      it "returns user" do
        expect(described_class.create_user_from_session(auth, email)).to be_a described_class
      end

      it "creates user" do
        expect { described_class.create_user_from_session(auth, email) }.to change(described_class, :count).by(1)
      end

      it "creates identity" do
        expect { described_class.create_user_from_session(auth, email) }.to change(Identity, :count).by(1)
      end

      it "creates identity with provider, uid and email", :aggregate_failures do
        identity = described_class.create_user_from_session(auth, email).identities.first

        expect(identity.provider).to eq auth.provider
        expect(identity.uid).to eq auth.uid
        expect(identity.user.email).to eq auth.info.email
      end

      it "does not skips confirmation" do
        expect(described_class.create_user_from_session(auth, email).confirmed?).to be false
      end
    end

    context "without email" do
      it "returns user" do
        expect(described_class.create_user_from_session(auth, email: nil)).to be_a described_class
      end

      it "does not creates user" do
        expect { described_class.create_user_from_session(auth, email: nil) }.not_to change(described_class, :count)
      end
    end
  end

  describe ".create_identities" do
    it "creates identity" do
      expect { described_class.create_user_from_auth(auth) }.to change(Identity, :count).by(1)
    end

    it "creates identity with provider and uid", :aggregate_failures do
      identity = described_class.create_user_from_auth(auth).identities.first

      expect(identity.provider).to eq auth.provider
      expect(identity.uid).to eq auth.uid
    end
  end
end
