require "rails_helper"

shared_examples "searching" do |query, type|
  let(:model) do
    type == "all" ? ThinkingSphinx : type.underscore.classify.constantize
  end

  it "receives perform_search for Search" do
    expect(Search).to receive(:perform_search).with(query, type)
    Search.query(query, type)
  end
end

RSpec.describe Search, type: :sphinx do
  describe "::SEARCH_TYPES" do
    it "returns search_types" do
      expect(described_class::SEARCH_TYPES).to eq %w(all question answer comment user)
    end
  end

  describe ".perform_search" do
    it "receives escaped data", :aggregate_failures do
      query = "need@escape.com"
      escaped = Riddle::Query.escape(query)
      expect(Riddle::Query).to receive(:escape).with(query).and_call_original
      expect(ThinkingSphinx).to receive(:search).with(escaped)
      described_class.perform_search(query, "all")
    end
  end

  describe ".query" do
    it "searches", :aggregate_failures do
      user = create(:user)
      question = create(:question, user: user)
      answer = create(:answer, question: question, user: user)
      comment = create(:comment, commentable: answer, user: user)
      index
      expect(described_class.query("", "all")).to match_array [user, question, answer, comment]
      expect(described_class.query(question.title, "question")).to match_array [question]
      expect(described_class.query(answer.body, "answer")).to match_array [answer]
      expect(described_class.query(comment.body, "comment")).to match_array [comment]
      expect(described_class.query(user.email, "user")).to match_array [user]
    end

    described_class::SEARCH_TYPES.each do |search_type|
      it_behaves_like "searching", "query", search_type
    end

    context "bad search type" do
      it "not receives perform_search for Search" do
        expect(described_class).not_to receive(:perform_search).with("query", "bad_type")
        described_class.query("query", "bad_type")
      end

      it "returns []" do
        expect(described_class.query("query", "bad_type")).to eq []
      end
    end
  end
end
