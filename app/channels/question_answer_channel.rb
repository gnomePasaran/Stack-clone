# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class QuestionAnswerChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "question:#{data['question_id'].to_i}:answers"
  end

  def unfollow
    stop_all_streams
  end
end
