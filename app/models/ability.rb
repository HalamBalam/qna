# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [Question, Answer, Comment]
      can [:update, :destroy], [Question, Answer], user_id: user.id
      
      can :vote, [Question, Answer] do |votable|
        votable.user.id != user.id && !user.voted_for?(votable)
      end

      can :revote, [Question, Answer] do |votable|
        votable.user.id != user.id && user.voted_for?(votable)
      end

      can :destroy, ActiveStorage::Attachment do |file|
        file.record.user.id == user.id
      end

      can :destroy, Link do |link|
        link.linkable.user.id == user.id
      end

      can :mark_answer_as_best, Answer do |answer|
        answer.question.user.id == user.id && !answer.best?
      end
    end
  end
end
