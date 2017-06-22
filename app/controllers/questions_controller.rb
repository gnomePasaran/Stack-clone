class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :build_answer, :set_subscription, only: :show

  include Voted

  respond_to :html, except: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    authorize Question
    respond_with(@question = current_user.questions.new)
  end

  def create
    authorize Question
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    render status: :unprocessable_entity unless @question.update(question_params)
  end

  def destroy
    respond_with @question.destroy, location: root_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
    authorize @question
  end

  def build_answer
    @answer = @question.answers.build
  end

  def set_subscription
    @subscription = Subscription.find_by(question: @question, user: current_user)
  end
end
