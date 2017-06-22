class QuestionAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    Subscription.includes(:user).where(question_id: question.id).where.not(user_id: answer.user_id).find_each do |subscription|
      QuestionMailer.new_answer(subscription.user, question, answer).deliver_later
    end
  end
end
