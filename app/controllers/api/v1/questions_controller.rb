class Api::V1::QuestionsController < Api::V1::ApplicationController
  def index
    respond_with Question.all
  end

  def create
    authorize Question
    @question = Question.create(question_params.merge(user: current_user))
    respond_with @question, include: ""
  end

  def show
    @question = Question.find(params[:id])
    authorize @question
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
