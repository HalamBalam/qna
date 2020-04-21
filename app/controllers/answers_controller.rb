class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :update, :destroy, :mark_as_best]
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
    
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    @question = @answer.question

    if current_user&.author?(@answer)
      @answer.update(answer_params)
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

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

end
