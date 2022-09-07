FactoryBot.define do
  factory :priority do
    trait :high do
      id { 1 }
      name { '高' }
    end

    trait :middle do
      id { 2 }
      name { '中' }
    end

    trait :low do
      id { 3 }
      name { '低' }
    end
  end
end
