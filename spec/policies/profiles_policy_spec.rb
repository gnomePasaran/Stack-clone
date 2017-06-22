require "rails_helper"

RSpec.describe ProfilesPolicy do
  let(:record) { :profiles }

  permissions :me?, :all? do
    it_grants_access
    it_behaves_like "access denied for guest"
  end
end
