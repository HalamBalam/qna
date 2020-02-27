class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :user

  default_scope { order(best: :desc) }

  validates :body, presence: true

  def best!
    return if best?

    answer = question.answers.where(best: true).first
    if answer
      answer.update!(best: false)
    end

    update!(best: true)
  end

end
