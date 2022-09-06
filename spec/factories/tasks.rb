FactoryBot.define do
  factory :task, class: 'Task' do
    sequence(:name) { |n| "task name#{n}" }
    sequence(:detail) { |n| "task detail#{n}" }
    deadline { Time.zone.tomorrow }
    task_status_id { 1 }

    association :task_status
  end
end
