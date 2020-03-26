require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
  validate :validate_url

  def validate_url
    errors.add(:url) unless url =~ /\A#{URI::regexp}\z/
  end

  def gist?
    url =~ /\Ahttps:\/\/gist.github.com\/([a-zA-Z0-9_\.-]+)\/([a-zA-Z0-9_\.-]{32})/  
  end
end
