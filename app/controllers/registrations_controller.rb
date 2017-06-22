class RegistrationsController < ApplicationController
  before_action :redirect_if_signed_in, :redirect_if_no_oauth_session
  skip_after_action :verify_authorized

  def finish_signup
  end

  def send_confirmation_email
    user = User.find_by(email: params[:email])

    if user.present?
      flash[:notice] = "User with provided email already registered"
    else
      @user = User.create_user_from_session(session["devise.oauth_data"], params[:email])
      return sign_in_with_oauth(@user, session["devise.oauth_data"]["provider"]) if @user.persisted?
    end

    render :finish_signup
  end

  private

  def redirect_if_no_oauth_session
    redirect_to root_path, notice: "Registration successfully finished" unless session["devise.oauth_data"]
  end
end
