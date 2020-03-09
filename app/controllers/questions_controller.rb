class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :delete_file]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
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
      @question.title = question_params[:title]
      @question.body = question_params[:body]
      @question.save
      
      @question.files.attach(question_params[:files]) unless question_params[:files].nil?
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

  def delete_file
    if current_user&.author?(@question)
      @question.files.find(params[:file_id]).purge
      @question.reload
    end
    
    render 'update'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

end
