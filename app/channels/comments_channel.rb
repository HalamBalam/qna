class CommentsChannel < ApplicationCable::Channel
  
  def follow(data)
    stream_from "comments_for_question_#{data['question_id']}" if data['question_id'].present?
  end

end
