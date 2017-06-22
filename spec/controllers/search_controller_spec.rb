require "rails_helper"

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    it "returns http success and renders search template" do
      get :search
      expect(response).to have_http_status :success
      expect(response).to render_template :search
    end

    it "assigns @results with [] if invalid search_type" do
      get :search, params: { search_type: "" }
      expect(assigns(:results)).to eq []
    end

    it "receives query and perform_search for Search" do
      question = double(:question, title: "Question title")
      expect(Search).to receive(:query).with(question.title, "all").and_call_original
      expect(Search).to receive(:perform_search).with(question.title, "all").and_return([question])
      get :search, params: { search_query: question.title, search_type: "all" }
    end

    it "not receives perform_search for Search if bad type" do
      question = double(:question, title: "Question title")
      expect(Search).to receive(:query).with(question.title, "").and_call_original
      expect(Search).not_to receive(:perform_search).with(question.title, "")
      get :search, params: { search_query: question.title, search_type: "" }
    end
  end
end
