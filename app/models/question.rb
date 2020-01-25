class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  
  validates :title, :body, presence: true

  before_destroy :before_destroy_delete_answers

  private

  def before_destroy_delete_answers
    Answer.where(question: self).destroy_all
  end

end
