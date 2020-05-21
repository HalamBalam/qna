class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :update, :destroy, :mark_as_best]
  before_action :load_question, only: [:new, :create]

  after_action :publish_answer, only: [:create]

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
