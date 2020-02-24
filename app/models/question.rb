class Question < ApplicationRecord

  belongs_to :user
  has_many :answers, dependent: :destroy
  
  validates :title, :body, presence: true

  def best_answer
    Answer.find(best_answer_id) unless best_answer_id.nil?
  end

  def ordered_answers
    Answer.joins(:question).where(question: self).select('answers.*', 'questions.best_answer_id = answers.id AS best_answer').order('best_answer DESC')
  end

  def best_answer=(new_best_answer)
    if new_best_answer.nil?
      self.best_answer_id = nil
    else
      self.best_answer_id = new_best_answer.id
    end
  end

end
