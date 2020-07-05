class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_subscription, only: [:destroy]

  def create
    authorize! :subscribe, @question

    @subscription = current_user.subscriptions.new
    @subscription.question = @question
    @subscription.save

    render partial: 'questions/subscription_actions'
  end

  def destroy
    authorize! :unsubscribe, @question

    @subscription.destroy

    render partial: 'questions/subscription_actions'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
  end
end
