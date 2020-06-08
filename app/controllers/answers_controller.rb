class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :update, :destroy, :mark_as_best]
  before_action :load_question, only: [:new, :create]

  after_action :publish_answer, only: [:create]

  authorize_resource

  skip_authorize_resource :except => [:index, :show, :new, :create, :update, :destroy]
  skip_authorization_check :except => [:index, :show, :new, :create, :update, :destroy]

  def index
  end

  def show
    render partial: 'answers/answer', locals: { answer: @answer }
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
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    authorize! :mark_answer_as_best, @answer

    @question = @answer.question
    @answer.best!

    render 'update'
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?
    
    ActionCable.server.broadcast(
      "answers_for_question_#{@answer.question.id}",
      ApplicationController.render(json: { id: @answer.id,
                                           user: @answer.user.id,
                                           author_of_question: @answer.question.user.id,
                                           html: ApplicationController.render(partial: 'answers/answer_cable', locals: { answer: @answer }) 
                                         } ))
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

end
