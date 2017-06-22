require "rails_helper"

RSpec.describe AnswerPolicy do
  let(:record) { build_stubbed(:answer, user: user) }

  permissions :create? do
    let(:record) { Answer }

    it_grants_access
    it_behaves_like "access denied for guest"
  end

  permissions :update?, :destroy? do
    it_grants_access
    it_behaves_like "access denied for non-author"
    it_behaves_like "access denied for guest"
  end

  permissions :accept? do
    let(:question) { build_stubbed(:question, user: user) }
    let(:record) { build_stubbed(:answer, question: question) }

    it_grants_access
    it_behaves_like "access denied for author"
    it_behaves_like "access denied for non-author"
    it_behaves_like "access denied for guest"
  end

  permissions :vote? do
    it_denies_access
    it_behaves_like "access denied for guest"
    it_behaves_like "access allowed for non-author"
  end
end
