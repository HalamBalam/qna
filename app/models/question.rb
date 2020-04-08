class Question < ApplicationRecord
  belongs_to :user

  has_one :reward, dependent: :destroy
  has_many :answers, -> { order(best: :desc, created_at: :desc) }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
end
