require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_gon_user
  after_action :verify_authorized, unless: :devise_controller?, except: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_gon_user
    gon.user_id = current_user.try(:id)
  end

  def sign_in_with_oauth(user, provider)
    sign_in_and_redirect user, event: :authentication
    flash[:notice] = t("devise.omniauth_callbacks.success", kind: provider.to_s.camelize) if is_navigational_format?
  end

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
      format.any(:js, :json) { head :forbidden }
    end
  end

  def redirect_if_signed_in(path = root_path)
    redirect_to path if signed_in?
  end
end
