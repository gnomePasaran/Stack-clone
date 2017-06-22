require "rails_helper"

RSpec.describe CommentPolicy do
  permissions :create? do
    let(:record) { Answer }

    it_grants_access
    it_behaves_like "access denied for guest"
  end
end
