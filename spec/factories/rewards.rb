FactoryBot.define do
  factory :reward do
    question
    name { "RewardName" }
    image { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/rails_helper.rb'))) }
  end
end
