class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show, :update, :destroy]

  def index
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    
    if @answer.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
