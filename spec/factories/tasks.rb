FactoryBot.define do
  factory :task, class: Task do
    name { "task name" }
    detail { "task detail" }
  end
end
