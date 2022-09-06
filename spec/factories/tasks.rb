FactoryBot.define do
  factory :task, class: 'Task' do
    sequence(:name) { |n| "task name#{n}" }
    sequence(:detail) { |n| "task detail#{n}" }
    deadline { '2023-08-01 12:00:00 +0900' }
  end
end
