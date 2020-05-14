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

  def model_klass
    params[:context].classify.constantize
  end

  def attr_id
    "#{params[:context]}_id".to_sym
  end

  def set_commentable
    @commentable = model_klass.find(params[attr_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    
    ActionCable.server.broadcast(
      "comments",
      ApplicationController.render(json: { id: @comment.id,
                                           user: @comment.user.email,
                                           body: @comment.body,
                                           context: @commentable.class.to_s.downcase,
                                           commentable_id: @commentable.id } ))
  end

end
