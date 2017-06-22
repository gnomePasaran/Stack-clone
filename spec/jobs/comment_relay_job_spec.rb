require "rails_helper"

RSpec.describe CommentRelayJob, type: :job do
  let(:channel) { "question:#{record.commentable_id}:comments" }
  let(:hash) { { commentable: record.commentable_type.underscore, commentable_id: record.commentable_id } }

  context "question" do
    let(:record) { create(:question_comment) }

    it_behaves_like "broadcast to ActionCable"
    it_behaves_like "job perform"
  end

  context "answer" do
    let(:channel) { "question:#{record.commentable.question_id}:comments" }
    let(:record) { create(:answer_comment) }

    it_behaves_like "broadcast to ActionCable"
    it_behaves_like "job perform"
  end
end
