class VotesController < ApplicationController

  before_action :authenticate_user!

  load_resource

  def destroy
    authorize! :revote, @vote.votable
    
    @vote.destroy

    respond_to do |format|
      if current_user&.voted_for?(@vote.votable)
        format.json do
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      else
        format.json { render json: [@vote.rating] }
      end
    end

  end

end
