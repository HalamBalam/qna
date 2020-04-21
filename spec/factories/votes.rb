FactoryBot.define do
  factory :vote do
    votable { nil }
    user
    rating { 0 }
  end
end
