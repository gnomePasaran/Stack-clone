require "rails_helper"

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  subject(:create_subscription) { post :create, params: { id: question, format: :json } }
  subject(:delete_subscription) { delete :destroy, params: { id: question, format: :json } }

  describe "POST #create" do
    context "as user", :users, :auth do
      it "returns http created", :aggregate_failures do
        create_subscription
        expect(response).to have_http_status(:created)
      end

      it "creates subscription" do
        expect { create_subscription }.to change(Subscription, :count).by(1)
      end
    end

    context "as guest" do
      it "returns http unauthorized" do
        create_subscription
        expect(response).to have_http_status :unauthorized
      end

      it "doesn't creates subscription" do
        expect { create_subscription }.not_to change(Subscription, :count)
      end
    end
  end

  describe "POST #destroy" do
    context "as user", :users, :auth do
      before do
        create(:subscription, user: user, question: question)
      end

      it "returns http success" do
        delete_subscription
        expect(response).to have_http_status(:success)
      end

      it "deletes subscription" do
        expect { delete_subscription }.to change(Subscription, :count).by(-1)
      end
    end

    context "as guest" do
      it "returns http unauthorized" do
        delete_subscription
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
