module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_yes, :vote_no]
    
    skip_authorize_resource :only => [:vote_yes, :vote_no]
    skip_authorization_check :only => [:vote_yes, :vote_no]
  end

  def vote_yes
    vote(1)
  end

  def vote_no
    vote(-1)
  end

  private

  def vote(rating)
    authorize! :vote, @votable

    vote = @votable.votes.new
    vote.user = current_user
    vote.rating = rating

    respond_to do |format|
      if vote.save
        format.json { render json: vote }
      else
        format.json do
          render json: vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
  
end
