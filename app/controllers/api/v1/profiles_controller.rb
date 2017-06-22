class Api::V1::ProfilesController < Api::V1::ApplicationController
  def me
    authorize :profiles
    respond_with current_resource_owner
  end

  def all
    authorize :profiles
    respond_with User.where.not(id: current_resource_owner)
  end
end
