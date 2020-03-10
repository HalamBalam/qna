class AttachedFilesController < ApplicationController

  before_action :authenticate_user!

  def delete_question_file
    @question = Question.find(params[:id])

    if current_user&.author?(@question)
      @question.files.find(params[:file_id]).purge
      @question.reload
    end
    
    render 'questions/update'
  end

  def delete_answer_file
    @answer = Answer.find(params[:id])

    if current_user&.author?(@answer)
      @answer.files.find(params[:file_id]).purge

      @question = @answer.question
      @question.reload
    end
    
    render 'answers/update'
  end

end
