class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create, :update, :destroy, :accept]
  before_action :set_answer, only: [:update, :destroy, :accept]

  include Voted

  respond_to :json, except: :accept
  respond_to :html, only: :accept

  def create
    authorize Answer
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
    respond_with @answer, location: @question
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    respond_with @answer.destroy
  end

  def accept
    @answer.toggle_accept!
    respond_with @answer, location: question_path(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
    authorize @answer
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
