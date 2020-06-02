FactoryBot.define do
  factory :authorization do
    user
    provider { "MyString" }
    uid { "MyString" }
    confirmed { false }
  end
end
