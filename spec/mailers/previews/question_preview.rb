# Preview all emails at http://localhost:3000/rails/mailers/question
class QuestionPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/question/digest
  def digest
    user = User.new(email: "test@example.com")
    questions = [Question.new(title: "New question")]
    QuestionMailer.digest(user, questions)
  end

  # Preview this email at http://localhost:3000/rails/mailers/question/new_answer
  def new_answer
    user = User.new(email: "test@example.com")
    question = Question.new(title: "New question")
    answer = Answer.new(body: "New answer")
    QuestionMailer.new_answer(user, question, answer)
  end

  # Preview this email at http://localhost:3000/rails/mailers/question/update
  def update
    user = User.new(email: "test@example.com")
    question = Question.new(title: "New question")
    QuestionMailer.update(user, question)
  end
end
