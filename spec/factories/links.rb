FactoryBot.define do
  factory :link do
    linkable { nil }
    name { "Thinknetica" }
    url { "https://thinknetica.com/" }

    trait :invalid do
      url { "https:||thinknetica.com/" }  
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/HalamBalam/54d7c4f3e3b74eea57348ef9292fe780/" }  
    end
  end
end
