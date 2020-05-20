class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def set_commentable
    klass = [Answer, Question].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    
    question_id = @commentable.is_a?(Answer) ? @commentable.question.id : @commentable.id

    ActionCable.server.broadcast(
      "comments_for_question_#{question_id}",
      ApplicationController.render(json: { email: @comment.user.email,
                                           user: @comment.user.id,
                                           body: @comment.body,
                                           context: @commentable.class.to_s.downcase,
                                           commentable_id: @commentable.id } ))
  end

end
