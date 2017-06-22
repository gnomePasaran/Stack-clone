# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class QuestionsChannel < ApplicationCable::Channel
  def follow
    stop_all_streams
    stream_from "questions"
  end

  def unfollow
    stop_all_streams
  end
end
