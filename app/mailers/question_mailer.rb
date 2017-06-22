class QuestionMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email
  end

  def new_answer(user, question, answer)
    @question = question
    @answer = answer
    mail to: user.email, subject: t("question_mailer.new_answer.subject", question_title: question.title)
  end

  def update(user, question)
    @question = question
    mail to: user.email, subject: t("question_mailer.update.subject", question_title: question.title)
  end
end
