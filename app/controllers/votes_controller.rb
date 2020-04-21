class VotesController < ApplicationController

  before_action :authenticate_user!

  def destroy
    vote = Vote.find(params[:id])

    return author_error_response unless current_user&.votes.include?(vote)

    vote.destroy

    respond_to do |format|
      if current_user&.voted_for?(vote.votable)
        format.json do
          render json: vote.errors.full_messages, status: :unprocessable_entity
        end
      else
        format.json { render json: [vote.rating] }
      end
    end

  end

  private

  def author_error_response
    respond_to do |format|
      format.json { render json: ['You could re-vote only for your votes'], status: :unprocessable_entity }  
    end
  end

end
