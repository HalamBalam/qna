module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    return 0 if votes.count == 0

    votes.select('SUM(rating) as rating')[0][:rating]
  end

end
