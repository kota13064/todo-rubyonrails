FactoryBot.define do
  factory :task, class: 'Task' do
    sequence(:name) { |n| "task name#{n}" }
    sequence(:detail) { |n| "task detail#{n}" }
    deadline { Time.zone.tomorrow }
    task_status_id { 1 }
    priority_id { 1 }
  end
end
