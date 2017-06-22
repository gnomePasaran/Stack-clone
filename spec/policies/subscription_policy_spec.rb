require "rails_helper"

RSpec.describe SubscriptionPolicy do
  let(:record) { build_stubbed(:subscription, user: user) }

  permissions :create? do
    let(:record) { Subscription }

    it_grants_access
    it_behaves_like "access denied for guest"
  end

  permissions :destroy? do
    it_grants_access
    it_behaves_like "access denied for guest"
    it_behaves_like "access denied for non-author"
  end
end
