class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy
  
  has_many_attached :files

  validates :title, :body, presence: true
end
