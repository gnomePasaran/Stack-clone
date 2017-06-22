class QuestionRelayJob < ApplicationJob
  def perform(question)
    ActionCable.server.broadcast "questions",
                                 question: render_question(question)
  end

  private

  def render_question(question)
    CommentsController.render(partial: "questions/question_teaser", locals: { question: question })
  end
end
