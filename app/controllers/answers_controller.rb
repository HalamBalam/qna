class AnswersController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :destroy]
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

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      redirect_to @question, alert: 'The answer is invalid.'
    end
  end

  def destroy
    if current_user&.is_author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
    else
      redirect_to answer_path(@answer), notice: 'User is not the author of the answer.'
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
