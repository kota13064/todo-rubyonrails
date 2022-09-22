FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test name#{n}" }
    sequence(:email) { |n| "test_email#{n}@test.com" }
    sequence(:password) { |n| "password#{n}" }
    is_admin { false }

    trait :admin do
      is_admin { true }
    end
  end
end
