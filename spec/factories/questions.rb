FactoryBot.define do
  factory :question do
    user
    title { "QuestionTitle" }
    body { "QuestionBody" }

    trait :invalid do
      title { nil }
    end
  end
end
