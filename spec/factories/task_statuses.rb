FactoryBot.define do
  factory :task_status do
    trait :todo do
      id { 1 }
      name { '未着手' }
    end

    trait :doing do
      id { 2 }
      name { '着手中' }
    end

    trait :done do
      id { 3 }
      name { '完了' }
    end
  end
end
