class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  respond_to :json

  def create
    authorize Subscription
    respond_with @question.subscriptions.create(user: current_user), location: @question
  end

  def destroy
    @subscription = @question.subscriptions.find_by!(user: current_user)
    authorize @subscription
    respond_with @subscription.destroy, location: @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
