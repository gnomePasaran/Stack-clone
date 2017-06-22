class QuestionUpdateNotifyJob < ApplicationJob
  queue_as :default

  def perform(question)
    Subscription.includes(:user).where(question_id: question.id).where.not(user_id: question.user_id).find_each do |subscription|
      QuestionMailer.update(subscription.user, question).deliver_later
    end
  end
end
