class CommentRelayJob < ApplicationJob
  def perform(comment)
    ActionCable.server.broadcast "question:#{channel_id(comment)}:comments",
                                 comment: render_comment(comment),
                                 commentable: comment.commentable_type.underscore,
                                 commentable_id: comment.commentable_id
  end

  private

  def render_comment(comment)
    CommentsController.render(partial: "comments/comment", locals: { comment: comment })
  end

  def channel_id(comment)
    comment.commentable_type == "Answer" ? comment.commentable.question_id : comment.commentable_id
  end
end
