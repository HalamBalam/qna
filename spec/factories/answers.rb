FactoryBot.define do
  factory :answer do
    user
    question
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
