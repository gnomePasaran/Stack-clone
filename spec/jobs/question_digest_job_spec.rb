require "rails_helper"

RSpec.describe QuestionDigestJob, type: :job do
  let(:mailer_double) { double(QuestionMailer) }
  let!(:question) { create(:question, created_at: 1.day.ago) }

  it "schedule emails for all users", :users do
    expect(QuestionMailer).to receive(:digest).and_return(mailer_double)
    expect(mailer_double).to receive(:deliver_later)
    described_class.perform_now
  end
end
