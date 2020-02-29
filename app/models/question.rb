class Question < ApplicationRecord

  belongs_to :user
  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy
  
  validates :title, :body, presence: true

end
