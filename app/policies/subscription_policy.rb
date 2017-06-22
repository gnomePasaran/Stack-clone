class SubscriptionPolicy < ApplicationPolicy
  def destroy?
    manage?
  end
end
