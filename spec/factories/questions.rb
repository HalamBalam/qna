FactoryBot.define do
  factory :question do
    user
    title { "QuestionTitle" }
    body { "QuestionBody" }

    trait :invalid do
      title { nil }
    end

    trait :with_attached_files do
      files { [
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))),
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
      ] }
    end
  end
end
