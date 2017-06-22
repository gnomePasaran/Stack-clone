require "rails_helper"

RSpec.describe QuestionAnswerNotificationJob, type: :job do
  let!(:record) { create(:answer) }
  let(:mailer_double) { double(QuestionMailer) }

  it "schedule emails for subscribed users on question", :users do
    expect(QuestionMailer).to receive(:new_answer).and_return(mailer_double)
    expect(mailer_double).to receive(:deliver_later)
    described_class.perform_now(record)
  end

  it_behaves_like "job perform"
end
