class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show, :partial]
  before_action :load_question, only: [:show, :update, :destroy, :partial]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new

    gon.current_user = current_user.id if user_signed_in?
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new(question: @question)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user&.author?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user&.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to question_path(@question), notice: 'User is not the author of the question.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(partial: 'questions/question', locals: { question: @question }))
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url], reward_attributes: [:name, :image])
  end

end
