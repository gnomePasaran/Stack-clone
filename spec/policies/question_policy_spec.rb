require "rails_helper"

RSpec.describe QuestionPolicy do
  let(:record) { build_stubbed(:question, user: user) }

  permissions :show? do
    let(:record) { create(:question) }

    it_behaves_like "access allowed for guest"
  end

  permissions :create? do
    let(:record) { Question }

    it_grants_access
    it_behaves_like "access denied for guest"
  end

  permissions :update?, :destroy? do
    it_grants_access
    it_behaves_like "access denied for non-author"
    it_behaves_like "access denied for guest"
  end

  permissions :vote? do
    it_denies_access
    it_behaves_like "access denied for guest"
    it_behaves_like "access allowed for non-author"
  end
end
