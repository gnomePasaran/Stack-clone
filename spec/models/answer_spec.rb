require "rails_helper"

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe "toggle accepted" do
    it "toggles" do
      answer = create(:answer)
      expect { answer.toggle_accept! }.to change { answer.reload.accepted }.from(false).to(true)
    end

    it "untoggles" do
      answer = create(:answer, accepted: true)
      expect { answer.toggle_accept! }.to change { answer.reload.accepted }.from(true).to(false)
    end

    it "toggles new answer" do
      answer = build(:answer)
      expect { answer.toggle_accept! }.to change { answer.accepted }.from(false).to(true)
    end

    it "untoggles new answer" do
      answer = build(:answer, accepted: true)
      expect { answer.toggle_accept! }.to change { answer.accepted }.from(true).to(false)
    end
  end

  it_behaves_like "perform relay job after commit" do
    let(:job) { QuestionAnswerRelayJob }
    let(:subject) { build(:answer) }
  end

  context "Subscription" do
    let(:answer) { build(:answer) }
    it "performs QuestionAnswerNotificationJob" do
      expect(QuestionAnswerNotificationJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
