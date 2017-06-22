require "rails_helper"

RSpec.describe ApplicationPolicy do
  let(:record) { described_class }

  permissions :index? do
    it_grants_access
  end

  permissions :update?, :destroy?, :edit? do
    it_denies_access
  end
end
