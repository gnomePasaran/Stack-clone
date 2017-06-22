require "rails_helper"

RSpec.describe QuestionAnswerRelayJob, type: :job do
  let(:record) { create(:answer) }
  let(:channel) { "question:#{record.question_id}:answers" }

  it_behaves_like "broadcast to ActionCable"
  it_behaves_like "job perform"
end
