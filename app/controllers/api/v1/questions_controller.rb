class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :update, :destroy]

  authorize_resource
  
  def index
    @questions = Question.all.sort
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner
    
    if @question.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url])
  end
end
