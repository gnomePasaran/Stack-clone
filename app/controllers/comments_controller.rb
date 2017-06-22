class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

  respond_to :json

  def create
    authorize Comment
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save
    respond_with @comment, location: root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    commentable_name.classify.constantize
  end

  def commentable_name
    params[:commentable]
  end

  def set_commentable
    @commentable = model_klass.find(params["#{commentable_name.singularize}_id"])
  end
end
