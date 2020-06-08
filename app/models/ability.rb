# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [Question, Answer, Comment]
      can [:update, :destroy], [Question, Answer], user_id: user.id
      
      can :vote, [Question, Answer] do |votable|
        !user.author?(votable) && !user.voted_for?(votable)
      end

      can :revote, [Question, Answer] do |votable|
        !user.author?(votable) && user.voted_for?(votable)
      end

      can :destroy, ActiveStorage::Attachment do |file|
        user.author?(file.record)
      end

      can :destroy, Link do |link|
        user.author?(link.linkable)
      end

      can :mark_answer_as_best, Answer do |answer|
        user.author?(answer.question) && !answer.best?
      end
    end
  end
end
