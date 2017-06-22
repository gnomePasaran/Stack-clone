# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "question:#{data['commentable_id'].to_i}:comments"
  end

  def unfollow
    stop_all_streams
  end
end
