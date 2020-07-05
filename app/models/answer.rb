class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :notify_question_subscribers

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      user.rewards << question.reward if question.reward.present? 
    end
  end

  private

  def notify_question_subscribers
    NotificationJob.perform_later(question)
  end

end
