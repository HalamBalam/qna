FactoryBot.define do
  factory :comment do
    commentable { nil }
    user
    body { 'CommentBody' }

    trait :invalid do
      body { nil }
    end
  end
end
