require "rails_helper"

shared_examples "renders the headers" do |subject|
  it "renders the headers" do
    expect(mail.subject).to eq(subject)
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["from@example.com"])
  end
end

RSpec.describe QuestionMailer, type: :mailer do
  let(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }

  describe "digest", :users do
    let(:mail) { described_class.digest(user, questions) }

    it_behaves_like "renders the headers", "Daily Questions Digest"

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello! Here is the digest of new questions for last 24 hours!")
      expect(mail.body.encoded).to match(questions.first.title)
      expect(mail.body.encoded).to match(questions.second.title)
      expect(mail.body.encoded).to match(url_for(questions.first))
      expect(mail.body.encoded).to match(url_for(questions.second))
    end
  end

  describe "new_answer", :users do
    let(:answer) { create(:answer, question: question) }
    let(:mail) { described_class.new_answer(user, question, answer) }

    # TODO: to shared
    it "renders the headers" do
      expect(mail.subject).to eq("New answer for question \"#{question.title}\"")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for question \"#{question.title}\":")
      expect(mail.body.encoded).to match(answer.body)
      expect(mail.body.encoded).to match("Click on the following link to view question online:")
      expect(mail.body.encoded).to match(url_for(question))
    end
  end

  describe "update" do
    let(:mail) { described_class.update(question.user, question) }

    # TODO: to shared
    it "renders the headers" do
      expect(mail.subject).to eq("Question updated: #{question.title}")
      expect(mail.to).to eq([question.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Following Question has been updated:")
      expect(mail.body.encoded).to match(question.title)
      expect(mail.body.encoded).to match("Click on the following link to view question online:")
      expect(mail.body.encoded).to match(url_for(question))
    end
  end
end
