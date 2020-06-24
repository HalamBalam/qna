FactoryBot.define do
  factory :answer do
    user
    question
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end

    trait :with_attached_files do
      files { [
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))),
        Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/spec_helper.rb')))
      ] }
    end

    trait :with_links do
      links_attributes {
        [{ name: 'google', url: 'https://www.google.ru/' }, { name: 'yandex', url: 'https://yandex.ru/' }]
      }
    end
  end
end
