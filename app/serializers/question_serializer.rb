class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :body, :created_at, :updated_at, :files

  has_many :comments
  has_many :links

  def files
    result = []

    object.files.each do |file|
      result << Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end

    result
  end

end
