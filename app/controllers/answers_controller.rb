class AnswersController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :update, :destroy, :mark_as_best, :delete_file]
  before_action :load_question, only: [:new, :create]

  def index
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @question = @answer.question

    if current_user&.author?(@answer)
      @answer.body = answer_params[:body]
      @answer.save

      @answer.files.attach(answer_params[:files]) unless answer_params[:files].nil?
    end
  end

  def destroy
    if current_user&.author?(@answer)
      @answer.destroy
    end
  end

  def mark_as_best
    @question = @answer.question

    if current_user&.author?(@question)
      @answer.best!
    end

    render 'update'
  end

  def delete_file
    if current_user&.author?(@answer)
      @answer.files.find(params[:file_id]).purge

      @question = @answer.question
      @question.reload
    end
    
    render 'update'
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

end
