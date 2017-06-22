shared_context "shared policy", type: :policy do
  subject { described_class }

  let(:guest) { nil }
  let(:user) { build_stubbed(:user) }
  let(:admin) { build_stubbed(:user, admin: true) }
  let(:pundit_user) { user }
end

shared_examples "access denied for guest" do
  let(:pundit_user) { guest }

  it_denies_access
end

shared_examples "access denied for non-author" do
  let(:pundit_user) { build_stubbed(:user) }

  it_denies_access
end

shared_examples "access denied for author" do
  let(:pundit_user) { record.user }

  it_denies_access
end

shared_examples "access allowed for non-author" do
  let(:pundit_user) { build_stubbed(:user) }

  it_grants_access
end

shared_examples "access allowed for guest" do
  let(:pundit_user) { guest }

  it_grants_access
end
