module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, -> { order(:created_at) }, dependent: :destroy, as: :commentable
  end

end
