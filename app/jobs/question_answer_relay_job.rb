class QuestionAnswerRelayJob < ApplicationJob
  def perform(answer)
    ActionCable.server.broadcast "question:#{answer.question_id}:answers",
                                 answer: answer
  end
end
