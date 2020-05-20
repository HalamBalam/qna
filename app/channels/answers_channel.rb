class AnswersChannel < ApplicationCable::Channel
  
  def follow(data)
    stream_from "answers_for_question_#{data['question_id']}" if data['question_id'].present?
  end
  
end
