require "rails_helper"

RSpec.describe QuestionRelayJob, type: :job do
  let(:record) { create(:question) }
  let(:channel) { "questions" }

  it_behaves_like "broadcast to ActionCable"
  it_behaves_like "job perform"
end
