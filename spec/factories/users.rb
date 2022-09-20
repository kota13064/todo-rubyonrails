FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test name#{n}" }
    sequence(:email) { |n| "test_email#{n}@test.com" }
    sequence(:password) { |n| "password#{n}" }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
