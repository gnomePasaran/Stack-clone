require "rails_helper"

describe "Profile API" do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  context "authorized" do
    describe 'GET #me' do
      before do
        get "/api/v1/profiles/me", params: { access_token: access_token.token, format: :json }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).not_to have_json_path(attr)
        end
      end
    end

    describe 'GET #all' do
      let!(:user) { create(:user) }

      before do
        get "/api/v1/profiles/all", params: { access_token: access_token.token, format: :json }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "includes user" do
        expect(response.body).to include_json(user.to_json)
      end

      it "does not includes signed in user" do
        expect(response.body).not_to include_json(me.to_json)
      end

      it "returns 1 user" do
        expect(response.body).to have_json_size(1)
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).not_to have_json_path("0/#{attr}")
        end
      end
    end
  end

  context "not authorized" do
    describe 'GET #me' do
      it_behaves_like "API unaccessable", :get, "/api/v1/profiles/me"
    end

    describe 'GET #all' do
      it_behaves_like "API unaccessable", :get, "/api/v1/profiles/all"
    end
  end
end
